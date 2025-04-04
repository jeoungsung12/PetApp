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
    private let locationManager = CLLocationManager()
    private let authorizationStatusSubject = BehaviorRelay<CLAuthorizationStatus>(value: CLLocationManager.authorizationStatus())
    private let locationButton = UIButton()
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        LoadingIndicator.showLoading()
        
        output.mapResult
            .drive(with: self) { owner, entity in
                owner.mapView.removeAnnotations(owner.mapView.annotations)
                let annotations = entity.map { CustomAnnotation(entity: $0) }
                owner.mapView.addAnnotations(annotations)
                
                let _ = entity.map { CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.lon) }
                let region = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
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
            .subscribe(onNext: { [weak self] status in
                guard let self = self else { return }
                switch status {
                case .notDetermined:
                    self.locationManager.requestWhenInUseAuthorization()
                case .restricted, .denied:
                    self.showSettingsAlert()
                case .authorizedWhenInUse, .authorizedAlways:
                    self.moveToUserLocation()
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func configureView() {
        self.setNavigation(color: .clear)
        mapView.delegate = self
        mapView.showsUserLocation = true
        locationManager.delegate = self
        
        locationButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
        locationButton.tintColor = .point
        locationButton.backgroundColor = .white
        locationButton.layer.cornerRadius = 25
        locationButton.clipsToBounds = true
    }
    
    override func configureHierarchy() {
        self.view.addSubview(mapView)
        self.view.addSubview(locationButton)
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
    }
    
    private func moveToUserLocation() {
        if let userLocation = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(
                center: userLocation,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
            mapView.setRegion(region, animated: true)
        }
    }
    
    private func showSettingsAlert() {
        let alert = UIAlertController(
            title: "위치 권한 필요",
            message: "위치 서비스를 사용하려면 설정에서 권한을 허용해주세요.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        })
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(alert, animated: true)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatusSubject.accept(status)
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            moveToUserLocation()
        }
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
