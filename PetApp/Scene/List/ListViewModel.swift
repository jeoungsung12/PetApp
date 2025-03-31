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
        let errorResult: Driver<DataDreamError>
    }
}

extension ListViewModel {
    
    func transform(_ input: Input) -> Output {
        let homeResult = BehaviorRelay<[HomeEntity]>(value: [])
        let errorResult = PublishRelay<DataDreamError>()
        
        input.loadTrigger
            .withUnretained(self)
            .flatMapLatest { owner, page -> Single<[HomeEntity]> in
                return Single<[HomeEntity]>.create { single in
                    Task {
                        do {
                            owner.page += 1
                            let value = homeResult.value
                            let result = try await owner.fetchData(value, page)
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
        
        return Output(
            homeResult: homeResult,
            errorResult: errorResult.asDriver(onErrorJustReturn: DataDreamError.serverError)
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
