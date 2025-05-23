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
    case middlePhoto
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
    private let repository: NetworkRepositoryType
    private var disposeBag = DisposeBag()
    
    struct Input {
        let loadTrigger: PublishRelay<Void>
    }
    
    struct Output {
        let homeResult: Driver<[HomeSection]>
        let errorResult: Driver<AnimalError>
    }
    
    init(
        repository: NetworkRepositoryType? = nil
    ) {
        self.repository = repository ?? DIContainer.shared.resolve(type: NetworkRepository.self)!
    }
    
}

extension HomeViewModel {
    
    func transform(_ input: Input) -> Output {
        let homeResult = BehaviorRelay<[HomeSection]>(value: [])
        let errorResult = PublishRelay<AnimalError>()
        
        input.loadTrigger
            .withUnretained(self)
            .flatMapLatest { owner, _ -> Single<[HomeSection]> in
                return Single<[HomeSection]>.create { single in
                    Task {
                        do {
                            let result = try await owner.fetchData()
                            single(.success(result))
                        } catch {
                            if let dataDreamError = error as? AnimalError {
                                errorResult.accept(dataDreamError)
                            } else {
                                errorResult.accept(AnimalError.serverError)
                            }
                            single(.success(homeResult.value))
                        }
                    }
                    return Disposables.create()
                }
            }
            .bind(to: homeResult)
            .disposed(by: disposeBag)
        
        return Output(
            homeResult: homeResult.asDriver(onErrorJustReturn: []),
            errorResult: errorResult.asDriver(onErrorJustReturn: AnimalError.serverError)
        )
    }
    
    private func fetchData() async throws -> [HomeSection] {
        do {
            let firstResult = try await repository.getAnimal(1, regionCode: nil)
            let secondResult = firstResult.dropFirst(10).prefix(10)
            
            return [
                HomeSection(title: "", items: [.init(data: nil)]),
                HomeSection(title: "전국에서 도움을\n기다리고 있어요! 🏡", items: firstResult.prefix(5).map {
                    return HomeItem(data: $0)
                }),
                HomeSection(title: "", items: [.init(data: nil)]),
                HomeSection(title: "전국 보호소 스냅 📸", items: firstResult.dropFirst(4).prefix(6).map {
                    return HomeItem(data: $0)
                }),
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
