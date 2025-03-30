//
//  RecordViewModel.swift
//  PetApp
//
//  Created by 정성윤 on 3/30/25.
//

import Foundation
import RxSwift
import RxCocoa

final class RecordViewModel: BaseViewModel {
    private let realmRepo: UserRepositoryType = RealmUserRepository.shared
    private var disposeBag = DisposeBag()
    
    struct Input {
        let loadTrigger: PublishRelay<Void>
    }
    
    struct Output {
        let recordResult: Driver<[RecordRealmEntity]>
    }
    
}

extension RecordViewModel {
    
    func transform(_ input: Input) -> Output {
        let recordResult = BehaviorRelay(value: realmRepo.getAllRecords())
        
        input.loadTrigger
            .withUnretained(self)
            .map { owner, _ in
                return owner.realmRepo.getAllRecords()
            }
            .bind(to: recordResult)
            .disposed(by: disposeBag)
        
        return Output(
            recordResult: recordResult.asDriver()
        )
    }
}
