//
//  ListViewModel.swift
//  PetApp
//
//  Created by 정성윤 on 3/27/25.
//

import Foundation
import RxSwift
import RxCocoa

final class ListViewModel: BaseViewModel {
    private let repository: NetworkRepositoryType = NetworkRepository.shared
    private var disposeBag = DisposeBag()
    private(set) var page: Int = 1
    
    struct Input {
        let loadTrigger: PublishRelay<Int>
    }
    
    struct Output {
        let homeResult: BehaviorRelay<[HomeEntity]>
    }
}

extension ListViewModel {
    
    func transform(_ input: Input) -> Output {
        let homeResult = BehaviorRelay<[HomeEntity]>(value: [])
        
        input.loadTrigger
            .flatMapLatest { [weak self] page -> Single<[HomeEntity]> in
                return Single<[HomeEntity]>.create { single in
                    Task {
                        do {
                            self?.page += 1
                            let value = homeResult.value
                            let result = try await self?.fetchData(value, page)
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
            homeResult: homeResult
        )
    }
    
    private func fetchData(_ value: [HomeEntity], _ page: Int) async throws -> [HomeEntity] {
        do {
            let result = try await repository.getAnimal(page)
            return value + result
        } catch {
            throw error
        }
    }
    
}
