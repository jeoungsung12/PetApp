//
//  MapViewController.swift
//  PetApp
//
//  Created by 정성윤 on 3/27/25.
//

import UIKit
import SnapKit
import MapKit
import RxSwift
import RxCocoa

final class MapViewController: BaseViewController {
    private let mapView = MKMapView()
    private let viewModel: MapViewModel
    private var disposeBag = DisposeBag()
    private let locationRepository = LocationRepository.shared
    private let authorizationStatusSubject = BehaviorRelay<CLAuthorizationStatus>(value: CLLocationManager.authorizationStatus())
    private let locationButton = UIButton()
    private let refreshButton = UIButton()
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadingIndicator.showLoading()
        
        locationRepository.requestLocationAuthorization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func setBinding() {
        let input = MapViewModel.Input(
            loadTrigger: Observable.just(())
        )
        let output = viewModel.transform(input)
        
        locationRepository.authorizationStatus
            .bind(to: authorizationStatusSubject)
            .disposed(by: disposeBag)
        
        locationRepository.currentLocation
            .compactMap { $0 }
            .distinctUntilChanged { $0.latitude == $1.latitude && $0.longitude == $1.longitude }
            .bind(with: self) { owner, location in
                let regionCode = RegionCodeMapper.getRegionCode(
                    latitude: location.latitude,
                    longitude: location.longitude
                )
                
                owner.viewModel.updateRegionCode(regionCode)
            }
            .disposed(by: disposeBag)
        
        output.mapResult
            .drive(with: self) { owner, entity in
                owner.mapView.removeAnnotations(owner.mapView.annotations)
                let annotations = entity.map { CustomAnnotation(entity: $0) }
                owner.mapView.addAnnotations(annotations)
                
                let center = owner.viewModel.mapType == .hospital && owner.locationRepository.currentLocation.value != nil
                ? owner.locationRepository.currentLocation.value!
                : CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780)
                
                let region = MKCoordinateRegion(
                    center: center,
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                )
                owner.mapView.setRegion(region, animated: true)
                LoadingIndicator.hideLoading()
            }
            .disposed(by: disposeBag)
        
        output.errorResult
            .drive(with: self) { owner, error in
                let errorVM = ErrorViewModel(notiType: .player)
                let errorVC = ErrorViewController(viewModel: errorVM, errorType: error)
                errorVC.modalPresentationStyle = .overCurrentContext
                owner.present(errorVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        locationButton.rx.tap
            .withLatestFrom(authorizationStatusSubject)
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, status in
                switch status {
                case .notDetermined:
                    owner.locationRepository.requestLocationAuthorization()
                case .restricted, .denied:
                    owner.showSettingsAlert(title: "위치 권한 필요", message: "위치 서비스를 사용하려면 설정에서 권한을 허용해주세요.")
                case .authorizedWhenInUse, .authorizedAlways:
                    owner.moveToUserLocation()
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        refreshButton.rx.tap
            .withUnretained(self)
            .filter { owner, _ in owner.viewModel.mapType == .hospital }
            .withLatestFrom(authorizationStatusSubject)
            .bind(with: self, onNext: { owner, status in
                if status == .authorizedWhenInUse || status == .authorizedAlways {
                    LoadingIndicator.showLoading()
                    let newInput = MapViewModel.Input(loadTrigger: Observable.just(()))
                    let newOutput = owner.viewModel.transform(newInput)
                    newOutput.mapResult.drive(with: self, onNext: { owner, entity in
                        owner.mapView.removeAnnotations(owner.mapView.annotations)
                        let annotations = entity.map { CustomAnnotation(entity: $0) }
                        owner.mapView.addAnnotations(annotations)
                        owner.moveToUserLocation()
                        LoadingIndicator.hideLoading()
                    }).disposed(by: owner.disposeBag)
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func configureView() {
        self.setNavigation(color: .clear)
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        locationButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
        locationButton.tintColor = .point
        locationButton.backgroundColor = .white
        locationButton.layer.cornerRadius = 25
        locationButton.clipsToBounds = true
        
        refreshButton.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        refreshButton.tintColor = .point
        refreshButton.backgroundColor = .white
        refreshButton.layer.cornerRadius = 25
        refreshButton.clipsToBounds = true
        refreshButton.isHidden = viewModel.mapType != .hospital
    }
    
    override func configureHierarchy() {
        [mapView, locationButton, refreshButton].forEach {
            self.view.addSubview($0)
        }
    }
    
    override func configureLayout() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        locationButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.height.equalTo(50)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.trailing.equalTo(locationButton.snp.leading).offset(-12)
            make.centerY.equalTo(locationButton)
            make.width.height.equalTo(50)
        }
    }
    
    private func moveToUserLocation() {
        locationRepository.startUpdatingLocation(forceUpdate: true)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: CustomAnnotation.id)
        
        if annotationView == nil {
            annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: CustomAnnotation.id)
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
}
