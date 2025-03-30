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
        let searchText: PublishRelay<String>
    }
    
    struct Output {
        let recordResult: Driver<[RecordRealmEntity]>
    }
    
}

extension RecordViewModel {
    
    func transform(_ input: Input) -> Output {
        let recordResult = BehaviorRelay(value: realmRepo.getAllRecords())
        
        input.searchText
            .withUnretained(self)
            .map { owner, searchText in
                if searchText.isEmpty {
                    return owner.realmRepo.getAllRecords().reversed()
                } else {
                    return owner.realmRepo.getAllRecords().reversed().filter { record in
                        return record.location.contains(searchText) ||
                        record.title.contains(searchText) ||
                        record.subTitle.contains(searchText)
                    }
                }
            }
            .bind(to: recordResult)
            .disposed(by: disposeBag)
        
        input.loadTrigger
            .withUnretained(self)
            .map { owner, _ in
                return owner.realmRepo.getAllRecords().reversed()
            }
            .bind(to: recordResult)
            .disposed(by: disposeBag)
        
        return Output(
            recordResult: recordResult.asDriver()
        )
    }
}
