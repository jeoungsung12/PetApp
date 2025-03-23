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
    let description: String
    let shelter: String = "용인시 동물보호센터"
    let hashTag: String = "#용인시 #5개월령 추정 #얌전하고 귀여운 아이"
    let thumbImage: String = "mockImage"
}

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

final class HomeMockData {
    static let data: [HomeSection] = [
        HomeSection(title: "", items: Array(repeating: .init(data: HomeEntity(description: "푸들\n2023(년생) 3.82(kg)")), count: 6)),
        HomeSection(title: "도움이 필요해요 🚨", items: Array(repeating: .init(data: HomeEntity(description: "푸들\n2023(년생) 3.82(kg)")), count: 10)),
        HomeSection(title: "", items: [.init(data: HomeEntity(description: ""))]),
        HomeSection(title: "", items: [.init(data: HomeEntity(description: ""))]),
        HomeSection(title: "따스한 손길이\n필요한 친구들 🐾", items: Array(repeating: .init(data: HomeEntity(description: "푸들\n2023(년생) 3.82(kg)")), count: 5))
    ]
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
