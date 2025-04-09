//
//  ListViewModel.swift
//  PetApp
//
//  Created by 정성윤 on 3/27/25.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa

final class ListViewModel: BaseViewModel {
    private let repository: NetworkRepositoryType
    private var disposeBag = DisposeBag()
    private(set) var location: CLLocationCoordinate2D? = nil
    private(set) var page: Int = 1
    
    struct ListRequest {
        var page: Int
        var location: CLLocationCoordinate2D?
    }
    
    struct Input {
        let loadTrigger: PublishRelay<ListRequest>
    }
    
    struct Output {
        let homeResult: BehaviorRelay<[HomeEntity]>
        let errorResult: Driver<DataDreamError>
    }
    
    init(
        repository: NetworkRepositoryType? = nil
    ) {
        self.repository = repository ?? DIContainer.shared.resolve(type: NetworkRepositoryType.self)!
    }
}

extension ListViewModel {
    
    func transform(_ input: Input) -> Output {
        let homeResult = BehaviorRelay<[HomeEntity]>(value: [])
        let errorResult = PublishRelay<DataDreamError>()
        
        input.loadTrigger
            .withUnretained(self)
            .flatMapLatest {
                owner,
                request -> Single<[HomeEntity]> in
                return Single<[HomeEntity]>.create { single in
                    Task {
                        do {
                            owner.page += 1
                            owner.location = request.location
                            let value = homeResult.value
                            let result = try await owner.fetchData(
                                value,
                                request.page,
                                location: owner.location
                            )
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
    
    private func fetchData(_ value: [HomeEntity], _ page: Int, location: CLLocationCoordinate2D?) async throws -> [HomeEntity] {
        do {
            let result = try await repository.getAnimal(page, regionCode: location)
            return value + result
        } catch {
            throw error
        }
    }
    
}
