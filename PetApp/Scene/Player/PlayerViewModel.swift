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
    
    struct PlayerRequest {
        let start: Int
        let end: Int
    }
    
    private let repository: NetworkRepositoryType
    private var disposeBag = DisposeBag()
    private(set) var playerRequest: PlayerRequest?
    
    struct Input {
        let loadTrigger: PublishRelay<PlayerRequest>
    }
    
    struct Output {
        let errorResult: Driver<AnimalError>
        let videoResult: BehaviorRelay<[PlayerEntity]>
    }
    
    init(
        repository: NetworkRepositoryType? = nil
    ) {
        self.repository = repository ?? DIContainer.shared.resolve(type: NetworkRepositoryType.self)!
    }
    
}

extension PlayerViewModel {
    
    func transform(_ input: Input) -> Output {
        let videoResult = BehaviorRelay<[PlayerEntity]>(value: [])
        let errorResult = PublishRelay<AnimalError>()
        
        input.loadTrigger
            .compactMap { $0 }
            .withUnretained(self)
            .flatMapLatest { owner, request -> Single<[PlayerEntity]> in
                return Single<[PlayerEntity]>.create { single in
                    Task {
                        do {
                            owner.playerRequest = request
                            let result = try await owner.repository.getVideo(
                                start: request.start,
                                end: request.end
                            )
                            single(.success(owner.AppendOriginValue(videoResult, result.shuffled())))
                        } catch {
                            if let openSquareError = error as? AnimalError {
                                errorResult.accept(openSquareError)
                            } else {
                                errorResult.accept(AnimalError.serverError)
                            }
                            single(.success(videoResult.value))
                        }
                    }
                    return Disposables.create()
                }
            }
            .bind(to: videoResult)
            .disposed(by: disposeBag)
        
        return Output(
            errorResult: errorResult.asDriver(onErrorJustReturn: AnimalError.serverError),
            videoResult: videoResult
        )
    }
    
    private func AppendOriginValue(
        _ videoResult: BehaviorRelay<[PlayerEntity]>,
        _ resultValue: [PlayerEntity]
    ) -> [PlayerEntity] {
        var originValue = videoResult.value
        originValue.append(contentsOf: resultValue)
        return originValue
    }
}
