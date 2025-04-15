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
    private(set) var descriptionText = """
                                내용을 입력해 주세요
                                
                                친구들과 함께 했던 얘기를 자유롭게 얘기해보세요!
                                #봉사활동 #기록 #함께라서 행복 #얼른 가족만나길
                                """
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
