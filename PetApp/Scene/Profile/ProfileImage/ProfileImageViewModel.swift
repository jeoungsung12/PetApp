//
//  ProfileImageViewModel.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/7/25.
//

import Foundation
import RxSwift
import RxCocoa

enum ProfileData: String, CaseIterable {
    case profile0 = "sponsor1"
    case profile1 = "sponsor2"
    case profile2 = "sponsor3"
    case profile3 = "sponsor4"
    case profile4 = "sponsor5"
    case profile5 = "sponsor6"
    case profile6 = "sponsor7"
    case profile7 = "sponsor8"
}

final class ProfileImageViewModel: BaseViewModel {

    private var disposeBag = DisposeBag()
    
    struct Input {
        let backButtonTrigger: PublishSubject<Void>
    }
    
    struct Output {
        let backButtonResult: PublishSubject<Void> = PublishSubject()
    }
    
    init() {
        print(#function, self)
    }
    
    deinit {
        print(#function, self)
    }
    
}

extension ProfileImageViewModel {
    
    func transform(_ input: Input) -> Output {
        let output = Output()
        
        input.backButtonTrigger
            .bind(with: self, onNext: { owner, _ in
                output.backButtonResult.onNext(())
            }).disposed(by: disposeBag)
        
        return output
    }
    
}
