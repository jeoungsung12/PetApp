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

struct MapViewModel: BaseViewModel {
    private let repository: NetworkRepositoryType = NetworkRepository()
    private var disposeBag = DisposeBag()
    private(set) var mapType: MapType
    struct Input {
        let loadTrigger: Observable<Void>
    }
    
    struct Output {
        let mapResult: Driver<[MapEntity]>
    }
    
    init(mapType: MapType) {
        self.mapType = mapType
    }
}

extension MapViewModel {
    
    func transform(_ input: Input) -> Output {
        let mapResult = BehaviorRelay<[MapEntity]>(value: [])
        
        input.loadTrigger
            .flatMapLatest {
                Single.create { single in
                    Task {
                        do {
                            let result = try await repository.getMap(mapType)
                            single(.success(result))
                        } catch {
                            single(.failure(error))
                        }
                    }
                    return Disposables.create()
                }
            }
            .bind(to: mapResult)
            .disposed(by: disposeBag)
        
        return Output(
            mapResult: mapResult.asDriver()
        )
    }
    
}
