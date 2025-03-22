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

struct HomeEntity {
    let title: String = "용인시 동물보호센터"
    let category: String = "#용인시 #5개월령 추정 #얌전하고 귀여운 아이"
    let thumbImage: String = ""
}

enum HomeSectionType: CaseIterable {
    case header
    case middle
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

final class HomeMockData {
    static let data: [HomeSection] = Array(repeating: HomeSection(title: "도움!", items: Array(repeating: .init(data: HomeEntity()), count: 10)), count: 3)
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
        let homeResult: BehaviorRelay<[HomeSection]> = BehaviorRelay(value: HomeMockData.data)
        
        return Output(
            homeResult: homeResult.asDriver()
        )
    }
}
