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

protocol LocationRepositoryType: AnyObject {
    var currentLocation: BehaviorRelay<CLLocationCoordinate2D?> { get }
    var authorizationStatus: BehaviorRelay<CLAuthorizationStatus> { get }
    var currentAddress: BehaviorRelay<String?> { get }
    var currentCity: BehaviorRelay<String?> { get }
    
    func requestLocationAuthorization()
    func startUpdatingLocation(forceUpdate: Bool)
    func stopUpdatingLocation()
    func getUserLocationRegion(delta: Double) -> MKCoordinateRegion?
    func reverseGeocode(coordinate: CLLocationCoordinate2D, completion: ((String?, String?) -> Void)?)
}

final class LocationRepository: NSObject, LocationRepositoryType {
    static let shared: LocationRepositoryType = LocationRepository()
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    private var disposeBag = DisposeBag()
    
    private var lastLocationUpdateTime: Date?
    private let minLocationUpdateInterval: TimeInterval = 5 * 60
    
    let currentLocation = BehaviorRelay<CLLocationCoordinate2D?>(value: nil)
    let authorizationStatus = BehaviorRelay<CLAuthorizationStatus>(value: CLLocationManager.authorizationStatus())
    let currentAddress = BehaviorRelay<String?>(value: nil)
    let currentCity = BehaviorRelay<String?>(value: nil)
    
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
    
    func startUpdatingLocation(forceUpdate: Bool = false) {
        if forceUpdate || shouldUpdateLocation() {
            locationManager.startUpdatingLocation()
        }
    }
    
    private func shouldUpdateLocation() -> Bool {
        guard let lastUpdateTime = lastLocationUpdateTime else {
            return true
        }
        
        return Date().timeIntervalSince(lastUpdateTime) >= minLocationUpdateInterval
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
    
    @objc
    private func locationDidUpdate() {
        if let location = locationManager.location?.coordinate {
            currentLocation.accept(location)
        }
    }
    
    func reverseGeocode(coordinate: CLLocationCoordinate2D, completion: ((String?, String?) -> Void)? = nil) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self,
                  error == nil,
                  let placemark = placemarks?.first else {
                completion?(nil, nil)
                return
            }
            
            let address = self.createAddress(from: placemark)
            let city = placemark.locality ?? placemark.administrativeArea
            
            self.currentAddress.accept(address)
            self.currentCity.accept(city)
            
            completion?(address, city)
        }
    }
    
    private func createAddress(from placemark: CLPlacemark) -> String {
        var address = ""
        
        if let country = placemark.country {
            address += country
        }
        
        if let administrativeArea = placemark.administrativeArea {
            address += " " + administrativeArea
        }
        
        if let locality = placemark.locality {
            address += " " + locality
        }
        
        if let subLocality = placemark.subLocality {
            address += " " + subLocality
        }
        
        if let thoroughfare = placemark.thoroughfare {
            address += " " + thoroughfare
            
            if let subThoroughfare = placemark.subThoroughfare {
                address += " " + subThoroughfare
            }
        }
        
        return address.trimmingCharacters(in: .whitespaces)
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
        lastLocationUpdateTime = Date()
        
        currentLocation.accept(location)
        NotificationCenter.default.post(name: NSNotification.Name("locationDidUpdate"), object: nil)
        
        reverseGeocode(coordinate: location) { [weak self] _, _ in
            self?.stopUpdatingLocation()
        }
    }
}

//private var locationBtn = LocationButton()
//private let image = UIImage(systemName: "mappin.and.ellipse")
//
//private func bindView() {
//    locationBtn.rx.tap
//        .bind(with: self) { owner, _ in
//            owner.handleLocationButtonTap()
//        }
//        .disposed(by: disposeBag)
//}
//
//private func setupLocationButton() {
//    let locationRepository = LocationRepository.shared
//    locationBtn.configure(image: image, title: "위치 확인 중..")
//    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: locationBtn)
//
//    if locationRepository.authorizationStatus.value == .authorizedWhenInUse ||
//        locationRepository.authorizationStatus.value == .authorizedAlways {
//        locationRepository.startUpdatingLocation(forceUpdate: true)
//
//        locationRepository.currentCity
//            .compactMap { $0 }
//            .take(1)
//            .bind(with: self) { owner, city in
//                owner.locationBtn.configure(image: owner.image, title: city)
//                owner.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: owner.locationBtn)
//            }
//            .disposed(by: disposeBag)
//    } else {
//        locationBtn.configure(image: image, title: "전국")
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: locationBtn)
//    }
//}
//
//private func handleLocationButtonTap() {
//    let locationRepository = LocationRepository.shared
//
//    switch locationRepository.authorizationStatus.value {
//    case .authorizedWhenInUse, .authorizedAlways:
//        locationRepository.startUpdatingLocation(forceUpdate: true)
//        
//        locationRepository.currentCity
//            .compactMap { $0 }
//            .take(1)
//            .bind(with: self) { owner, city in
//                owner.locationBtn.configure(image: owner.image, title: city)
//                owner.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: owner.locationBtn)
//            }
//            .disposed(by: disposeBag)
//
//    case .denied, .restricted, .notDetermined:
//        showSettingsAlert(
//            title: "위치 권한 필요",
//            message: "위치 서비스를 사용하려면 설정에서 권한을 허용해주세요."
//        )
//    @unknown default:
//        break
//    }
//}
