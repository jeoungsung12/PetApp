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
    private let repository: NetworkRepositoryType = NetworkRepository()
    private var disposeBag = DisposeBag()
    
    struct Input {
        let loadTrigger: Observable<Void>
    }
    
    struct Output {
        let videoResult: Driver<[PlayerEntity]>
    }
    
}

extension PlayerViewModel {
    
    func transform(_ input: Input) -> Output {
        let videoResult = PublishRelay<[PlayerEntity]>()
        
        input.loadTrigger
            .flatMapLatest { [weak self] _ -> Single<[PlayerEntity]> in
                return Single<[PlayerEntity]>.create { single in
                    Task {
                        do {
                            let result = try await self?.repository.getVideo(start: 1, end: 5)
                            single(.success(result ?? []))
                        } catch {
                            single(.failure(error))
                        }
                    }
                    return Disposables.create()
                }
            }
            .bind(to: videoResult)
            .disposed(by: disposeBag)
        
        return Output(
            videoResult: videoResult.asDriver(onErrorJustReturn: [])
        )
    }
}
