//
//  WriteViewModel.swift
//  PetApp
//
//  Created by 정성윤 on 3/30/25.
//

import Foundation
import RxSwift
import RxCocoa

final class WriteViewModel: BaseViewModel {
    private let repo: RealmRepositoryType = RealmRepository.shared
    private var disposeBag = DisposeBag()
    
    struct Input {
        let saveTrigger: PublishRelay<RecordRealmEntity>
    }
    
    struct Output {
        let saveResult: Driver<Bool>
    }
    
}

extension WriteViewModel {
    
    func transform(_ input: Input) -> Output {
        let saveResult = PublishRelay<Bool>()
        
        input.saveTrigger
            .withUnretained(self)
            .map { owner, record in
                return owner.repo.saveRecord(record)
            }
            .bind(to: saveResult)
            .disposed(by: disposeBag)
        
        return Output(
            saveResult: saveResult.asDriver(onErrorJustReturn: false)
        )
    }
    
}
