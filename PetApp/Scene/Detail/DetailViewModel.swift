//
//  DetailViewModel.swift
//  PetApp
//
//  Created by 정성윤 on 3/24/25.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

enum DetailSectionType: CaseIterable {
    case header
    case middle
    case footer
}

struct DetailSection {
    var items: [DetailItem]
}

struct DetailItem {
    let data: HomeEntity
}

extension DetailSection: SectionModelType {
    typealias item = DetailItem
    
    init(original: DetailSection, items: [DetailItem]) {
        self = original
        self.items = items
    }
}

final class DetailViewModel: BaseViewModel {
    private var disposeBag = DisposeBag()
    private var model: HomeEntity
    
    struct Input {
        
    }
    
    struct Output {
        let detailResult: Driver<[DetailSection]>
    }
    
    init(model: HomeEntity) {
        self.model = model
        print(#function, self)
    }
    
    deinit {
        print(#function, self)
    }
}

extension DetailViewModel {
    
    func transform(_ input: Input) -> Output {
        let detailResult = BehaviorRelay(value: self.loadData())
        
        
        return Output(
            detailResult: detailResult.asDriver()
        )
    }
    
    private func loadData() -> [DetailSection] {
        let model = self.model
        
        return [
            DetailSection(items: [DetailItem(data: model)]),
            DetailSection(items: [DetailItem(data: model)]),
            DetailSection(items: [DetailItem(data: model)])
        ]
    }
    
}
