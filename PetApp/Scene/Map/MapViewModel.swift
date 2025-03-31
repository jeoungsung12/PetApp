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
        let errorResult: Driver<DataDreamError>
    }
    
    init(mapType: MapType) {
        self.mapType = mapType
    }
}

extension MapViewModel {
    
    func transform(_ input: Input) -> Output {
        let mapResult = BehaviorRelay<[MapEntity]>(value: [])
        let errorResult = PublishRelay<DataDreamError>()
        
        input.loadTrigger
            .flatMapLatest {
                Single.create { single in
                    Task {
                        do {
                            let result = try await repository.getMap(mapType)
                            single(.success(result))
                        } catch {
                            if let dataDreamError = error as? DataDreamError {
                                errorResult.accept(dataDreamError)
                            } else {
                                errorResult.accept(DataDreamError.serverError)
                            }
                            single(.success([]))
                        }
                    }
                    return Disposables.create()
                }
            }
            .bind(to: mapResult)
            .disposed(by: disposeBag)
        
        return Output(
            mapResult: mapResult.asDriver(),
            errorResult: errorResult.asDriver(onErrorJustReturn: DataDreamError.serverError)
        )
    }
    
}
