//
//  DetailMiddleViewModel.swift
//  PetApp
//
//  Created by 정성윤 on 3/28/25.
//

import Foundation
import RxSwift
import RxCocoa

import RxSwift
import RxCocoa

final class DetailMiddleViewModel: BaseViewModel {
    private let repo: UserRepositoryType = RealmUserRepository.shared
    private var disposeBag = DisposeBag()
    
    struct Input {
        let heartTapped: Observable<HomeEntity>
    }
    
    struct Output {
        let isLiked: Driver<Bool>
    }
    
    private let isLikedSubject = BehaviorSubject<Bool>(value: false)
    
    func transform(_ input: Input) -> Output {
        input.heartTapped
            .subscribe(onNext: { [weak self] entity in
                guard let self = self else { return }
                let isCurrentlyLiked = self.repo.isLiked(id: entity.animal.id)
                
                if isCurrentlyLiked {
                    self.repo.removeLikedHomeEntity(id: entity.animal.id)
                } else {
                    self.repo.saveLikedHomeEntity(entity)
                }
                
                let newIsLiked = !isCurrentlyLiked
                self.isLikedSubject.onNext(newIsLiked)
            })
            .disposed(by: disposeBag)
        
        let output = Output(
            isLiked: isLikedSubject.asDriver(onErrorJustReturn: false)
        )
        
        return output
    }
    
    func isLiked(id: String) -> Bool {
        return repo.isLiked(id: id)
    }
}
