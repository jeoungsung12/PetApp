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

struct ChatEntity {
    let type: ChatType
    let name: String = "푸들"
    let message: String
    let thumbImage: String = ""
}

final class ChatMock {
    static let data = [
        ChatEntity(type: .bot, message: "kajsld\nasdf\nasdf\nasdfas"),
        ChatEntity(type: .mine, message: "kajsld\nasdf"),
        ChatEntity(type: .bot, message: "asdf"),
        ChatEntity(type: .mine, message: "asdf"),
        ChatEntity(type: .bot, message: "l;jalsdj"),
        ChatEntity(type: .mine, message: "message: asd\na\nsdlkfjlkasdj\nnadsf"),
        ChatEntity(type: .bot, message: "dddd")
    ]
}

final class ChatDetailViewModel: BaseViewModel {
    private var disposeBag = DisposeBag()
    private let entity: HomeEntity
    
    struct Input {
        let loadTrigger: Observable<Void>
    }
    
    struct Output {
        let chatResult: Driver<[ChatEntity]>
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
        let chatResult: BehaviorRelay<[ChatEntity]> = BehaviorRelay(value: ChatMock.data)
        
        return Output(
            chatResult: chatResult.asDriver()
        )
    }
}
