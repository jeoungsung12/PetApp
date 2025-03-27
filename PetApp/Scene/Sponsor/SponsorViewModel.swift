//
//  SponsorViewModel.swift
//  PetApp
//
//  Created by 정성윤 on 3/27/25.
//

import Foundation
import RxSwift
import RxCocoa

final class SponsorViewModel: BaseViewModel {
    private var disposeBag = DisposeBag()
    private var data: [SponsorEntity] = [
        SponsorEntity(image: "", title: "동물자유연대", siteURL: "")
    ]
    
    struct SponsorEntity {
        let image: String
        let title: String
        let siteURL: String
    }
    
    struct Input {
        
    }
    
    struct Output {
        let sponsorResult: Driver<[SponsorEntity]>
    }
}

extension SponsorViewModel {
    
    func transform(_ input: Input) -> Output {
        let sponsorResult = BehaviorRelay<[SponsorEntity]>(value: [])
        return Output(
            sponsorResult: sponsorResult.asDriver()
        )
    }
}
