//
//  DetailMiddleViewModel.swift
//  PetApp
//
//  Created by 정성윤 on 3/28/25.
//

import Foundation
import RxSwift
import RxCocoa

protocol ShareDelegate: AnyObject {
    func activityShare(_ entity: HomeEntity)
}

final class DetailMiddleViewModel: BaseViewModel {
    private let repo: UserRepositoryType = RealmUserRepository.shared
    private var disposeBag = DisposeBag()
    
    private let entity: HomeEntity
    weak var delegate: ShareDelegate?
    struct Input {
        let heartTapped: ControlEvent<Void>
        let shareTapped: ControlEvent<Void>
    }
    
    struct Output {
        let isLikedResult: Driver<Bool>
    }
    
    init(entity: HomeEntity) {
        self.entity = entity
    }
}

extension DetailMiddleViewModel {
    func transform(_ input: Input) -> Output {
        let id = self.entity.animal.id
        let isLikedResult = BehaviorRelay<Bool>(value: self.isLiked(id: id))
        
        input.heartTapped
            .bind(with: self, onNext: { owner, _ in
                let isCurrentlyLiked = owner.repo.isLiked(id: id)
                if isCurrentlyLiked {
                    owner.repo.removeLikedHomeEntity(id: id)
                } else {
                    owner.repo.saveLikedHomeEntity(owner.entity)
                }
                
                let newIsLiked = !isCurrentlyLiked
                isLikedResult.accept(newIsLiked)
            })
            .disposed(by: disposeBag)
        
        input.shareTapped
            .bind(with: self, onNext: { owner, _ in
                owner.delegate?.activityShare(owner.entity)
            })
            .disposed(by: disposeBag)
        
        let output = Output(
            isLikedResult: isLikedResult.asDriver()
        )
        
        return output
    }
    
    func isLiked(id: String) -> Bool {
        return repo.isLiked(id: id)
    }
}
