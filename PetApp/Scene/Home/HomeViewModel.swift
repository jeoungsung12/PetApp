//
//  HomeViewModel.swift
//  PetApp
//
//  Created by 정성윤 on 3/22/25.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

enum HomeSectionType: CaseIterable {
    case header
    case middle
    case middleBtn
    case middleAds
    case footer
}

struct HomeSection {
    var title: String
    var items: [HomeItem]
}

struct HomeItem {
    let data: HomeEntity
}

extension HomeSection: SectionModelType {
    typealias item = HomeItem
    
    init(original: HomeSection, items: [HomeItem]) {
        self = original
        self.items = items
    }
}

final class HomeViewModel: BaseViewModel {
    private var disposeBag = DisposeBag()
    
    struct Input {
        
    }
    
    struct Output {
        let homeResult: Driver<[HomeSection]>
    }
    
}

extension HomeViewModel {
    
    func transform(_ input: Input) -> Output {
        let homeResult: BehaviorRelay<[HomeSection]> = BehaviorRelay(value: [])
        
        return Output(
            homeResult: homeResult.asDriver()
        )
    }
}
