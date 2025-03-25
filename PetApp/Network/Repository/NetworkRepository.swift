//
//  NetworkRepository.swift
//  PetApp
//
//  Created by 정성윤 on 3/24/25.
//

import Foundation

protocol NetworkRepositoryType: AnyObject {
    func getAnimal(_ page: Int) async throws -> [HomeEntity]
}

final class NetworkRepository: NetworkRepositoryType {
    static let shared: NetworkRepositoryType = NetworkRepository()
    private let network: NetworkManagerType = NetworkManager.shared
    
    func getAnimal(_ page: Int) async throws -> [HomeEntity] {
        do {
            let result: HomeResponseDTO = try await network.fetchData(DataDreamRouter.getAnimal(page: page))
            return result.toEntity()
        } catch {
            //TODO: CustomError
            throw error
        }
    }
    
}
