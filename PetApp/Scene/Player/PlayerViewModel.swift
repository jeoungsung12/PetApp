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
    
    private let repository: NetworkRepositoryType = NetworkRepository()
    private var disposeBag = DisposeBag()
    private(set) var playerRequest: PlayerRequest?
    
    struct Input {
        let loadTrigger: PublishRelay<PlayerRequest>
    }
    
    struct Output {
        let errorResult: Driver<OpenSquareError>
        let videoResult: BehaviorRelay<[PlayerEntity]>
    }
    
}

extension PlayerViewModel {
    
    func transform(_ input: Input) -> Output {
        let videoResult = BehaviorRelay<[PlayerEntity]>(value: [])
        let errorResult = PublishRelay<OpenSquareError>()
        
        input.loadTrigger
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
                            
                            guard let result = result else { return single(.failure(NSError()))}
                            single(.success(owner.AppendOriginValue(videoResult, result) ?? []))
                        } catch {
                            if let openSquareError = error as? OpenSquareError {
                                errorResult.accept(openSquareError)
                            } else {
                                errorResult.accept(OpenSquareError.serverError)
                            }
                            single(.success([]))
                        }
                    }
                    return Disposables.create()
                }
            }
            .bind(to: videoResult)
            .disposed(by: disposeBag)
        
        
        
        return Output(
            videoResult: videoResult,
            errorResult: errorResult.asDriver(onErrorJustReturn: NSError())
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
