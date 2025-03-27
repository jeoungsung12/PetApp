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
    let message: String = "안녕하세요! 뭐하세요? 머ㅣㄴ어리;ㅓㅣ먼이ㅓㄹ미ㅏ넝;ㅏㅣ러ㅣ;ㅁㄴ어ㅣ라ㅓ마ㅣㄴ어리ㅏ머니아ㅓ리ㅏ먼ㅇ;ㅣㅏ럼;ㅣㅏㅓㄴㅇ리ㅏ"
    let thumbImage: String = ""
}

final class ChatMock {
    static let data = [
        ChatEntity(type: .bot),
        ChatEntity(type: .mine),
        ChatEntity(type: .bot),
        ChatEntity(type: .mine),
        ChatEntity(type: .bot),
        ChatEntity(type: .mine),
        ChatEntity(type: .bot)
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
