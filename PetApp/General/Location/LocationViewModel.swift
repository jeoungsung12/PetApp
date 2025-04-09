//
//  LocationViewModel.swift
//  PetApp
//
//  Created by 정성윤 on 4/9/25.
//
import Foundation
import RxSwift
import RxCocoa
import CoreLocation

final class LocationViewModel: BaseViewModel {
    private var locationManager: LocationRepositoryType
    private var disposeBag = DisposeBag()
    private(set) var coord2D: CLLocationCoordinate2D? = nil
    
    struct LocationEntity {
        var city: String
        var location: CLLocationCoordinate2D?
    }
    
    struct Input {
        let loadTrigger: PublishRelay<Void>
    }
    
    struct Output {
        let locationResult: Driver<LocationEntity>
    }
    
    init(
        locationManager: LocationRepositoryType? = nil
    ) {
        self.locationManager = locationManager ?? DIContainer.shared.resolve(type: LocationRepositoryType.self)!
        self.locationManager.requestLocationAuthorization()
    }
}

extension LocationViewModel {
    func transform(_ input: Input) -> Output {
        let locationResult = PublishRelay<LocationEntity>()
        
        locationManager.authorizationStatus
            .filter { status in
                return status == .authorizedWhenInUse || status == .authorizedAlways
            }
            .take(1)
            .subscribe(onNext: { [weak self] _ in
                self?.locationManager.startUpdatingLocation(forceUpdate: true)
            })
            .disposed(by: disposeBag)
        
        locationManager.currentLocation
            .compactMap { $0 }
            .take(1)
            .bind(with: self, onNext: { owner, coordinate in
                owner.getUserLocation { city in
                    owner.coord2D = coordinate
                    locationResult.accept(.init(city: city, location: coordinate))
                }
            })
            .disposed(by: disposeBag)
        
        input.loadTrigger
            .bind(with: self, onNext: { owner, _ in
                if let currentLocation = owner.locationManager.currentLocation.value {
                    owner.getUserLocation { city in
                        owner.coord2D = currentLocation
                        locationResult.accept(.init(city: city, location: currentLocation))
                    }
                } else {
                    locationResult.accept(.init(city: "전국", location: nil))
                }
            })
            .disposed(by: disposeBag)
        
        return Output(
            locationResult: locationResult.asDriver(
                onErrorJustReturn: .init(city: "전국", location: nil)
            )
        )
    }
    
    private func getUserLocation(completion: @escaping (String) -> Void) {
        guard let location = locationManager.currentLocation.value else {
            return completion("전국")
        }
        
        locationManager.reverseGeocode(coordinate: location) { address, city in
            completion(city ?? "전국")
        }
    }
    
    func geocodeCity(city: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        if city == "전국" {
            completion(nil)
            return
        }
        locationManager.geocodeAddress(address: city, completion: completion)
    }
}
