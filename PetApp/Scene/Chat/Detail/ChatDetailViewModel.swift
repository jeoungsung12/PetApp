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
    private var disposeBag = DisposeBag()
    private let entity: HomeEntity
    
    struct Input {
        
    }
    
    struct Output {
        
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
        
        return Output()
    }
}
