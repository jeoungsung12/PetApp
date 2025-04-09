//
//  PhotoViewModel.swift
//  PetApp
//
//  Created by 정성윤 on 4/5/25.
//

import Foundation
import RxSwift
import RxCocoa

final class PhotoViewModel: BaseViewModel {
    private let locationRepo: LocationRepositoryType
    private let repository: NetworkRepositoryType
    private var disposeBag = DisposeBag()
    private(set) var page: Int = 1
    private var locationCode: Int?
    
    struct Input {
        let loadTrigger: PublishRelay<Int>
    }
    
    struct Output {
        let homeResult: BehaviorRelay<[HomeEntity]>
        let errorResult: Driver<DataDreamError>
    }
    
    init(
        locationRepo: LocationRepositoryType? = nil,
        repository: NetworkRepositoryType? = nil
    ) {
        self.locationRepo = locationRepo ?? DIContainer.shared.resolve(type: LocationRepositoryType.self)!
        self.repository = repository ?? DIContainer.shared.resolve(type: NetworkRepositoryType.self)!
    }
}

extension PhotoViewModel {
    
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
            let result = try await repository.getAnimal(page, regionCode: nil)
            return value + result
        } catch {
            throw error
        }
    }
    
}
