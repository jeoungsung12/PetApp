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
        
        let result = output.mapResult
        result
            .drive(with: self) { owner, entity in
                owner.mapView.removeAnnotations(owner.mapView.annotations)
                let annotations = entity.map { CustomAnnotation(entity: $0) }
                owner.mapView.addAnnotations(annotations)
                
                let coordinates = entity.map { CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.lon) }
                let region = owner.calculateRegion(for: coordinates)
                owner.mapView.setRegion(region, animated: true)
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
    }
    
    override func configureView() {
        self.setNavigation(color: .clear)
        mapView.delegate = self
        //TODO: 사용자 위치 허락
//        mapView.showsUserLocation = true
    }
    
    override func configureHierarchy() {
        self.view.addSubview(mapView)
    }
    
    override func configureLayout() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    
    private func calculateRegion(for coordinates: [CLLocationCoordinate2D]) -> MKCoordinateRegion {
        guard !coordinates.isEmpty else {
            return MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )
        }
        let latitudes = coordinates.map { $0.latitude }
        let longitudes = coordinates.map { $0.longitude }
        
        let minLat = latitudes.min() ?? 0
        let maxLat = latitudes.max() ?? 0
        let minLon = longitudes.min() ?? 0
        let maxLon = longitudes.max() ?? 0
        
        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        let span = MKCoordinateSpan(
            latitudeDelta: (maxLat - minLat) * 1.5,
            longitudeDelta: (maxLon - minLon) * 1.5
        )
        
        return MKCoordinateRegion(center: center, span: span)
    }
    
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
