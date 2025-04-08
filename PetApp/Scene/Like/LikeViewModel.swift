//
//  LikeViewModel.swift
//  PetApp
//
//  Created by 정성윤 on 3/29/25.
//

import Foundation
import RxSwift
import RxCocoa

final class LikeViewModel: BaseViewModel {
    private var realmRepo: RealmRepositoryType
    private var disposeBag = DisposeBag()
    
    struct Input {
        let loadTrigger: PublishRelay<Void>
    }
    
    struct Output {
        let likeResult: Driver<[HomeEntity]>
    }
    
    init(
        realmRepo: RealmRepositoryType? = nil
    ) {
        self.realmRepo = realmRepo ?? DIContainer.shared.resolve(type: RealmRepositoryType.self)!
    }
}

extension LikeViewModel {
    
    func transform(_ input: Input) -> Output {
        let likeResult = BehaviorRelay<[HomeEntity]>(value: self.realmRepo.getAllLikedHomeEntities())
        
        input.loadTrigger
            .bind(with: self) { owner, _ in
                likeResult.accept(owner.realmRepo.getAllLikedHomeEntities())
            }
            .disposed(by: disposeBag)
        
        return Output(
            likeResult: likeResult.asDriver()
        )
    }
    
}
