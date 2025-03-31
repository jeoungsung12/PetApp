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
    private let realmRepo: RealmRepositoryType = RealmRepository.shared
    private let repository: NetworkRepositoryType = NetworkRepository.shared
    private var disposeBag = DisposeBag()
    private var likedEntities: [HomeEntity] = []
    
    init() {
        loadRealm()
    }
    
    struct Input {
        let loadTrigger: Observable<Void>
        let reloadRealm: PublishRelay<Void>
    }
    
    struct Output {
        let homeResult: Driver<[HomeSection]>
        let errorResult: Driver<DataDreamError>
    }
    
    func transform(_ input: Input) -> Output {
        let homeResult = BehaviorRelay<[HomeSection]>(value: [])
        let errorResult = PublishRelay<DataDreamError>()
        
        input.loadTrigger
            .withUnretained(self)
            .flatMapLatest { owner, _ -> Single<[HomeSection]> in
                return Single<[HomeSection]>.create { single in
                    Task {
                        do {
                            let result = try await owner.fetchData()
                            single(.success(result))
                        } catch {
                            if let dataDreamError = error as? DataDreamError {
                                errorResult.accept(dataDreamError)
                            } else {
                                errorResult.accept(DataDreamError.serverError)
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
        let result = try await repository.getAnimal(1)
        
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
        DispatchQueue.main.async { [weak self] in
            self?.likedEntities = self?.realmRepo.getAllLikedHomeEntities() ?? []
        }
    }
}
