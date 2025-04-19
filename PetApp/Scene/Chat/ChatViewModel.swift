//
//  ChatViewModel.swift
//  PetApp
//
//  Created by 정성윤 on 3/26/25.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

enum ChatSectionType: CaseIterable {
    case header
    case middle
    case footer
}

final class ChatViewModel: BaseViewModel {
    private let realmRepo: RealmRepositoryType
    private let repository: NetworkRepositoryType
    private var disposeBag = DisposeBag()
    private var likedEntities: [HomeEntity] = []
    
    init(
        realmRepo: RealmRepositoryType? = nil,
        repository: NetworkRepositoryType? = nil
    ) {
        self.realmRepo = realmRepo ?? DIContainer.shared.resolve(type: RealmRepository.self)!
        self.repository = repository ?? DIContainer.shared.resolve(type: NetworkRepository.self)!
        loadRealm()
    }
    
    struct Input {
        let loadTrigger: PublishRelay<Void>
        let reloadRealm: PublishRelay<Void>
    }
    
    struct Output {
        let homeResult: Driver<[HomeSection]>
        let errorResult: Driver<AnimalError>
    }
    
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
        
        input.reloadRealm
            .withUnretained(self)
            .map { owner, _ in
                owner.loadRealm()
                var value = homeResult.value
                if value.count > 0 {
                    value[value.count - 1] = HomeSection(title: "관심등록된 친구들 🐾", items: owner.likedEntities.map {
                        return HomeItem(data: $0)
                    })
                }
                return value
            }
            .bind(to: homeResult)
            .disposed(by: disposeBag)
        
        return Output(
            homeResult: homeResult.asDriver(onErrorJustReturn: []),
            errorResult: errorResult.asDriver(onErrorJustReturn: .serverError)
        )
    }
    
    private func fetchData() async throws -> [HomeSection] {
        let result = try await repository.getAnimal(1, regionCode: nil)
        
        return [
            HomeSection(title: "지금 도움이 필요한\n친구들과 대화해 보세요 💬", items: result.map {
                return HomeItem(data: $0)
            }),
            HomeSection(title: "", items: [.init(data: nil)]),
            HomeSection(title: "관심등록된 친구들 🐾", items: likedEntities.map {
                return HomeItem(data: $0)
            })
        ]
    }
    
    private func loadRealm() {
        self.likedEntities = self.realmRepo.getAllLikedHomeEntities()
    }
}
