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
    let data: HomeEntity?
}

extension HomeSection: SectionModelType {
    typealias item = HomeItem
    
    init(original: HomeSection, items: [HomeItem]) {
        self = original
        self.items = items
    }
}

final class HomeViewModel: BaseViewModel {
    private let repository: NetworkRepositoryType = NetworkRepository.shared
    private var disposeBag = DisposeBag()
    
    struct Input {
        let loadTrigger: Observable<Void>
    }
    
    struct Output {
        let homeResult: Driver<[HomeSection]>
    }
    
}

extension HomeViewModel {
    
    func transform(_ input: Input) -> Output {
        let homeResult = PublishRelay<[HomeSection]>()
        
        input.loadTrigger
            .flatMapLatest { [weak self] _ -> Single<[HomeSection]>  in
                return Single<[HomeSection]>.create { single in
                    Task {
                        do {
                            let result = try await self?.fetchData()
                            single(.success(result ?? []))
                        } catch {
                            single(.failure(error))
                        }
                    }
                    return Disposables.create()
                }
            }
            .bind(to: homeResult)
            .disposed(by: disposeBag)
        
        return Output(
            homeResult: homeResult.asDriver(onErrorJustReturn: [])
        )
    }
    
    private func fetchData() async throws -> [HomeSection] {
        do {
            async let firstResult = repository.getAnimal(1)
            async let secondResult = repository.getAnimal(2)
            
            return try await [
                HomeSection(title: "", items: Array(repeating: .init(data: nil), count: 6)),
                HomeSection(title: "도움이 필요해요!", items: firstResult.map {
                    return HomeItem(data: $0)
                }),
                HomeSection(title: "", items: [.init(data: nil)]),
                HomeSection(title: "", items: [.init(data: nil)]),
                HomeSection(title: "따스한 손길이\n필요한 친구들 🐾", items: secondResult.map {
                    return HomeItem(data: $0)
                })
            ]
            
        } catch {
            throw error
        }
    }
}
