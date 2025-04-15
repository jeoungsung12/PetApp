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
    let homeResult = BehaviorRelay<[HomeEntity]>(value: [])
    
    struct ListRequest {
        var page: Int
        var location: CLLocationCoordinate2D?
    }
    
    struct Input {
        let loadTrigger: PublishRelay<ListRequest>
    }
    
    struct Output {
        let homeResult: BehaviorRelay<[HomeEntity]>
        let errorResult: Driver<AnimalError>
    }
    
    init(
        repository: NetworkRepositoryType? = nil
    ) {
        self.repository = repository ?? DIContainer.shared.resolve(type: NetworkRepositoryType.self)!
    }
    
    func resetPage() {
        page = 1
    }
}

extension ListViewModel {
    
    func transform(_ input: Input) -> Output {
        let errorResult = PublishRelay<AnimalError>()
        
        input.loadTrigger
            .withUnretained(self)
            .flatMapLatest {
                owner,
                request -> Single<[HomeEntity]> in
                return Single<[HomeEntity]>.create { single in
                    Task {
                        do {
                            if request.page > 1 {
                                owner.page = request.page
                            }
                            owner.location = request.location
                            let existingData = request.page > 1 ? owner.homeResult.value : []
                            let result = try await owner.fetchData(
                                existingData,
                                request.page,
                                location: request.location
                            )
                            single(.success(result))
                        } catch {
                            if let dataDreamError = error as? AnimalError {
                                errorResult.accept(dataDreamError)
                            } else {
                                errorResult.accept(AnimalError.serverError)
                            }
                            single(.success(owner.homeResult.value))
                        }
                    }
                    return Disposables.create()
                }
            }
            .bind(to: homeResult)
            .disposed(by: disposeBag)
        
        return Output(
            homeResult: homeResult,
            errorResult: errorResult.asDriver(onErrorJustReturn: AnimalError.serverError)
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
