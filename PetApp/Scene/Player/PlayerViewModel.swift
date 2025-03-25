//
//  PlayerViewModel.swift
//  PetApp
//
//  Created by 정성윤 on 3/25/25.
//

import Foundation
import RxSwift
import RxCocoa

final class PlayerViewModel: BaseViewModel {
    
    private var disposeBag = DisposeBag()
    
    struct Input {
        let loadTrigger: Observable<Void>
    }
    
    struct Output {
        let videoResult: Driver<[String]>
    }
    
}

extension PlayerViewModel {
    
    func transform(_ input: Input) -> Output {
        let videoResult: PublishRelay<[String]> = PublishRelay()
        
        return Output(
            videoResult: videoResult.asDriver(onErrorJustReturn: [])
        )
    }
    
}
