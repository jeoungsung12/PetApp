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
    private var disposeBag = DisposeBag()
    private(set) var mapType: MapType
    struct Input {
        let loadTrigger: Observable<Void>
    }
    
    struct Output {
        let mapResult: Driver<[CLLocationCoordinate2D]>
    }
    
    init(mapType: MapType) {
        self.mapType = mapType
    }
}

extension MapViewModel {
    
    func transform(_ input: Input) -> Output {
        let mapResult = BehaviorRelay<[CLLocationCoordinate2D]>(value: [])
        return Output(
            mapResult: mapResult.asDriver()
        )
    }
    
}
