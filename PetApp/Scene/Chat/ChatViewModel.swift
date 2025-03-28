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
    private let repository: NetworkRepositoryType = NetworkRepository.shared
    private var disposeBag = DisposeBag()
    
    struct Input {
        let loadTrigger: Observable<Void>
    }
    
    struct Output {
        let homeResult: Driver<[HomeSection]>
    }
    
}

extension ChatViewModel {
    
    func transform(_ input: Input) -> Output {
        let homeResult = PublishRelay<[HomeSection]>()
        
        input.loadTrigger
            .flatMapLatest { [weak self] _ -> Single<[HomeSection]> in
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
            let result = try await repository.getAnimal(1)
            let firstResult = result.prefix(5)
            let secondResult = result.dropFirst(5).prefix(5)
            
            return [
                HomeSection(title: "지금 도움이 필요한\n친구들과 대화해 보세요 💬", items: firstResult.map {
                    return HomeItem(data: $0)
                }),
                HomeSection(title: "", items: [.init(data: nil)]),
                HomeSection(title: "관심등록된 친구들 🐾", items: secondResult.map {
                    return HomeItem(data: $0)
                })
            ]
            
        } catch {
            throw error
        }
    }
}
