//
//  RecordTableViewModel.swift
//  PetApp
//
//  Created by 정성윤 on 3/30/25.
//

import Foundation
import RxSwift
import RxCocoa

protocol RemoveDelegate: AnyObject {
    func remove()
}

final class RecordTableViewModel: BaseViewModel {
    private let repo: RealmRepositoryType = RealmRepository.shared
    private var disposeBag = DisposeBag()
    
    struct Input {
        let imageTrigger: PublishRelay<[String]>
        let removeTrigger: PublishRelay<RecordRealmEntity>
    }
    
    struct Output {
        let imageResult: Driver<[String]>
        let removeResult: Driver<Bool>
    }
}

extension RecordTableViewModel {
    
    func transform(_ input: Input) -> Output {
        let removeResult = PublishRelay<Bool>()
        
        input.removeTrigger
            .withUnretained(self)
            .map { owner, entity in
                return owner.repo.removeRecord(id: entity.date)
            }
            .bind(to: removeResult)
            .disposed(by: disposeBag)
        
        let imageResult = BehaviorRelay<[String]>(value: [])
        input.imageTrigger
            .bind(to: imageResult)
            .disposed(by: disposeBag)
        
        return Output(
            imageResult: imageResult.asDriver(),
            removeResult: removeResult.asDriver(onErrorJustReturn: false)
        )
    }
}
