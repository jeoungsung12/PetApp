//
//  MapViewModel.swift
//  PetApp
//
//  Created by 정성윤 on 3/27/25.
//

import Foundation
import RxSwift
import RxCocoa
import MapKit

enum MapType {
    case shelter
    case hospital
}

final class MapViewModel: BaseViewModel {
    private let repository: NetworkRepositoryType
    private let locationManager: LocationRepositoryType
    private var disposeBag = DisposeBag()
    private(set) var mapType: MapType
    
    struct Input {
        let loadTrigger: Observable<Void>
    }
    
    struct Output {
        let mapResult: Driver<[MapEntity]>
        let errorResult: Driver<AnimalError>
    }
    
    init(
        repository: NetworkRepositoryType? = nil,
        locationManager: LocationRepositoryType? = nil,
        mapType: MapType
    ) {
        self.repository = repository ?? DIContainer.shared.resolve(type: NetworkRepository.self)!
        self.locationManager = locationManager ?? DIContainer.shared.resolve(type: LocationRepositoryType.self)!
        self.mapType = mapType
    }
    
    func transform(_ input: Input) -> Output {
        let mapResult = BehaviorRelay<[MapEntity]>(value: [])
        let errorResult = PublishRelay<AnimalError>()
        
        input.loadTrigger
            .withUnretained(self)
            .flatMapLatest { owner, _ in
                Single.create { single in
                    Task {
                        do {
                            var result = try await owner.repository.getMap(owner.mapType)
                            if owner.mapType == .hospital,
                               let userLocation = owner.locationManager.currentLocation.value {
                                result = result.filter { entity in
                                    let location = CLLocation(latitude: entity.lat, longitude: entity.lon)
                                    let userLoc = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
                                    return location.distance(from: userLoc) <= 10000
                                }
                            }
                            single(.success(result))
                        } catch {
                            if let dataDreamError = error as? AnimalError {
                                errorResult.accept(dataDreamError)
                            } else {
                                errorResult.accept(AnimalError.serverError)
                            }
                            single(.success(mapResult.value))
                        }
                    }
                    return Disposables.create()
                }
            }
            .bind(to: mapResult)
            .disposed(by: disposeBag)
        
        return Output(
            mapResult: mapResult.asDriver(),
            errorResult: errorResult.asDriver(onErrorJustReturn: AnimalError.serverError)
        )
    }
}
