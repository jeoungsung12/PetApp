//
//  LocationRepository.swift
//  PetApp
//
//  Created by 정성윤 on 4/7/25.
//

import Foundation
import CoreLocation
import MapKit
import RxSwift
import RxCocoa

final class LocationRepository: NSObject {
    static let shared = LocationRepository()
    private let locationManager = CLLocationManager()
    private var disposeBag = DisposeBag()
    
    let currentLocation = BehaviorRelay<CLLocationCoordinate2D?>(value: nil)
    let authorizationStatus = BehaviorRelay<CLAuthorizationStatus>(value: CLLocationManager.authorizationStatus())
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(locationDidUpdate),
            name: NSNotification.Name("locationDidUpdate"),
            object: nil
        )
    }
    
    func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func getUserLocationRegion(delta: Double = 0.05) -> MKCoordinateRegion? {
        guard let userLocation = currentLocation.value else { return nil }
        
        return MKCoordinateRegion(
            center: userLocation,
            span: MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
        )
    }
    
    @objc private func locationDidUpdate() {
        if let location = locationManager.location?.coordinate {
            currentLocation.accept(location)
        }
    }
}

extension LocationRepository: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus.accept(status)
        
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last?.coordinate else { return }
        currentLocation.accept(location)
        NotificationCenter.default.post(name: NSNotification.Name("locationDidUpdate"), object: nil)
    }
    
}
