//
//  ChatDetailViewModel.swift
//  PetApp
//
//  Created by 정성윤 on 3/26/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

enum ChatType {
    case bot
    case mine
}

final class ChatDetailViewModel: BaseViewModel {
    private let repository: NetworkRepositoryType = NetworkRepository()
    private var disposeBag = DisposeBag()
    private let entity: HomeEntity
    
    struct Input {
        let loadTrigger: PublishRelay<String>
    }
    
    struct Output {
        let chatResult: Driver<[ChatEntity]>
        let errorResult: Driver<ChatError>
    }
    
    init(entity: HomeEntity) {
        self.entity = entity
    }
    
    deinit {
        print(#function, self)
    }
}

extension ChatDetailViewModel {
    
    func transform(_ input: Input) -> Output {
        let chatResult: BehaviorRelay<[ChatEntity]> = BehaviorRelay(value: [
            .init(type: .bot, name: entity.animal.name, message: "안녕하세요! 저에 대해 알고 싶으신가요? 편하게 질문해 주세요! 🐾", thumbImage: entity.animal.thumbImage)
        ])
        let errorResult = PublishRelay<ChatError>()
        
        input.loadTrigger
            .withUnretained(self)
            .flatMapLatest {
                owner,
                question in
                Single.create { single in
                    Task {
                        do {
                            chatResult.accept(owner.appendList(
                                chatResult.value,
                                ChatEntity(type: .mine, name: owner.entity.animal.name, message: question, thumbImage: owner.entity.animal.thumbImage))
                            )
                            
                            let result = try await owner.repository.getChatAnswer(entity: owner.entity, question: question)
                            single(.success(owner.appendList(chatResult.value, result)))
                        } catch {
                            if let chatError = error as? ChatError {
                                errorResult.accept(chatError)
                            } else {
                                errorResult.accept(ChatError.unsupportedRegion)
                            }
                            single(.success(chatResult.value))
                        }
                    }
                    return Disposables.create()
                }
            }
            .bind(to: chatResult)
            .disposed(by: disposeBag)
        
        return Output(
            chatResult: chatResult.asDriver(),
            errorResult: errorResult.asDriver(onErrorJustReturn: .unsupportedRegion)
        )
    }
    
    private func appendList(_ value: [ChatEntity],_ item: ChatEntity) -> [ChatEntity] {
        return value + [item]
    }
    
}
