//
//  NetworkRepository.swift
//  PetApp
//
//  Created by 정성윤 on 3/24/25.
//

import Foundation

protocol NetworkRepositoryType: AnyObject {
    func getAnimal(_ page: Int) async throws -> [HomeEntity]
    func getShelter() async throws -> [MapEntity]
    func getVideo(start: Int, end: Int) async throws -> [PlayerEntity]
    func getChatAnswer(entity: HomeEntity, question: String) async throws -> ChatEntity
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
    
    func getShelter() async throws -> [MapEntity] {
        do {
            let result: ShelterResponseDTO = try await network.fetchData(DataDreamRouter.getShelter)
            return result.toEntity()
        } catch {
            //TODO: CustomError
            throw error
        }
    }
    
    func getVideo(start: Int, end: Int) async throws -> [PlayerEntity] {
        do {
            let result: PlayerResponseDTO = try await network.fetchData(OpenSquareRouter.getVideo(startPage: start, endPage: end))
            return result.toEntity()
        } catch {
            throw error
        }
    }
    
    func getChatAnswer(entity: HomeEntity, question: String) async throws -> ChatEntity {
        do {
            let result: ChatResponseDTO = try await network.fetchData(ChatRouter.getChatAnswer(entity: entity, question: question))
            return ChatEntity(type: .bot, name: entity.animal.name, message: result.choices.first?.message.content ?? "", thumbImage: entity.animal.thumbImage)
        } catch {
            throw error
        }
    }
    
}
