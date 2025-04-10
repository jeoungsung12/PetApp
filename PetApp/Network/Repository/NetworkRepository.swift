//
//  NetworkRepository.swift
//  PetApp
//
//  Created by 정성윤 on 3/24/25.
//

import Foundation
import MapKit

protocol NetworkRepositoryType: AnyObject {
    func getAnimal(_ page: Int, regionCode: CLLocationCoordinate2D?) async throws -> [HomeEntity]
    func getMap(_ type: MapType) async throws -> [MapEntity]
    func getVideo(start: Int, end: Int) async throws -> [PlayerEntity]
    func getChatAnswer(entity: HomeEntity, question: String) async throws -> ChatEntity
}

final class NetworkRepository: NetworkRepositoryType {
    static let shared: NetworkRepositoryType = NetworkRepository()
    private let network: NetworkManagerType = NetworkManager.shared
    private let locationRepo = LocationRepository.shared
    
    func getAnimal(_ page: Int, regionCode: CLLocationCoordinate2D? = nil) async throws -> [HomeEntity] {
        do {
            let location = regionCode
            let regionCode: String?
            
            if let location = location {
                regionCode = RegionCodeMapper.getRegionCode(
                    latitude: location.latitude,
                    longitude: location.longitude
                )
            } else {
                regionCode = nil
            }
            let result: HomeResponseDTO = try await network.fetchData(DataDreamRouter.getAnimal(page: page, regionCode: regionCode))
            return result.toEntity()
        } catch {
            if let networkError = error as? NetworkError,
               let afError = networkError.error.asAFError,
               let statusCode = afError.responseCode,
               let responseData = networkError.responseData,
               let message = try? JSONSerialization.jsonObject(with: responseData) as? [String: Any],
               let errorMessage = message["message"] as? String {
                let customError = DataDreamError.mapToDataDreamError(statusCode: statusCode, message: errorMessage)
                throw customError
            } else {
                throw DataDreamError.serverError
            }
        }
    }
    
    func getMap(_ type: MapType) async throws -> [MapEntity] {
        do {
            switch type {
            case .shelter:
                let result: ShelterResponseDTO = try await network.fetchData(DataDreamRouter.getShelter)
                return result.toEntity()
            case .hospital:
                let request = MKLocalSearch.Request()
                request.naturalLanguageQuery = "동물병원"
                
                let search = MKLocalSearch(request: request)
                let response = try await search.start()
                
                let mapEntities = response.mapItems.map { item in
                    MapEntity(
                        name: item.name ?? "알 수 없는 병원",
                        number: item.phoneNumber ?? "전화번호 없음",
                        address: item.placemark.title ?? "주소 없음",
                        roadAddress: item.placemark.thoroughfare ?? "도로명 주소 없음",
                        numAddress: item.placemark.subThoroughfare ?? "지번 주소 없음",
                        lon: item.placemark.coordinate.longitude,
                        lat: item.placemark.coordinate.latitude
                    )
                }
                return mapEntities
            }
        } catch {
            if let networkError = error as? NetworkError,
               let afError = networkError.error.asAFError,
               let statusCode = afError.responseCode,
               let responseData = networkError.responseData,
               let message = try? JSONSerialization.jsonObject(with: responseData) as? [String: Any],
               let errorMessage = message["message"] as? String {
                let customError = DataDreamError.mapToDataDreamError(statusCode: statusCode, message: errorMessage)
                throw customError
            } else {
                throw DataDreamError.serverError
            }
        }
    }
    
    func getVideo(start: Int, end: Int) async throws -> [PlayerEntity] {
        do {
            let result: PlayerResponseDTO = try await network.fetchData(OpenSquareRouter.getVideo(startPage: start, endPage: end))
            return result.toEntity()
        } catch {
            if let networkError = error as? NetworkError,
               let afError = networkError.error.asAFError,
               let statusCode = afError.responseCode {
                let customError = OpenSquareError.mapToOpenSquareError(statusCode: "Error-\(statusCode)")
                throw customError
            } else {
                throw OpenSquareError.serverError
            }
        }
    }
    
    func getChatAnswer(entity: HomeEntity, question: String) async throws -> ChatEntity {
        do {
            let result: ChatResponseDTO = try await network.fetchData(ChatRouter.getChatAnswer(entity: entity, question: question))
            return ChatEntity(type: .bot, name: entity.animal.name, message: result.choices.first?.message.content ?? "", thumbImage: entity.animal.thumbImage)
        } catch {
            if let networkError = error as? NetworkError,
               let afError = networkError.error.asAFError,
               let statusCode = afError.responseCode,
               let responseData = networkError.responseData,
               let message = try? JSONSerialization.jsonObject(with: responseData) as? [String: Any],
               let errorMessage = message["message"] as? String {
                let customError = ChatError.mapToChatError(statusCode: statusCode, message: errorMessage)
                throw customError
            } else {
                throw ChatError.invalidAuthentication
            }
        }
    }
    
}
