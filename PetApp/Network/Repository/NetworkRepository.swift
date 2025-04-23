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
    func downloadImage(from urlString: String, completion: @escaping (URL?) -> Void)
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
            let result: HomeResponseDTO = try await network.fetchData(AnimalRouter.getAnimal(page: page, regionCode: regionCode))
            return result.toEntity()
        } catch {
            if let networkError = error as? NetworkError,
               let afError = networkError.error.asAFError,
               let statusCode = afError.responseCode {
                let customError = AnimalError.mapToError(statusCode: statusCode)
                throw customError
            } else {
                throw AnimalError.serverError
            }
        }
    }
    
    func getMap(_ type: MapType) async throws -> [MapEntity] {
        do {
            switch type {
            case .shelter:
                let result: ShelterResponseDTO = try await network.fetchData(AnimalRouter.getShelter)
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
               let statusCode = afError.responseCode {
                let customError = AnimalError.mapToError(statusCode: statusCode)
                throw customError
            } else {
                throw AnimalError.serverError
            }
        }
    }
    
    func getVideo(start: Int, end: Int) async throws -> [PlayerEntity] {
        do {
            let result: PlayerResponseDTO = try await network.fetchData(AnimalRouter.getVideo(startPage: start, endPage: end))
            return result.toEntity()
        } catch {
            if let networkError = error as? NetworkError,
               let afError = networkError.error.asAFError,
               let statusCode = afError.responseCode {
                let customError = AnimalError.mapToError(statusCode: statusCode)
                throw customError
            } else {
                throw AnimalError.serverError
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
               let statusCode = afError.responseCode {
                let customError = ChatError.mapToChatError(statusCode: statusCode)
                throw customError
            } else {
                throw ChatError.invalidAuthentication
            }
        }
    }
    
    func downloadImage(from urlString: String, completion: @escaping (URL?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                  let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            let resizedImage = self.resizeImageForWidget(image, maxSize: 400)
            guard let resizedData = resizedImage.jpegData(compressionQuality: 0.8) else {
                completion(nil)
                return
            }
            
            if let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.Warala.SeSAC") {
                let fileName = UUID().uuidString + ".jpg"
                let fileURL = containerURL.appendingPathComponent(fileName)
                
                do {
                    try resizedData.write(to: fileURL)
                    completion(fileURL)
                } catch {
                    print("이미지 저장 실패: \(error)")
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    
    private func resizeImageForWidget(_ image: UIImage, maxSize: CGFloat = 800) -> UIImage {
        let aspectRatio = image.size.width / image.size.height
        var newSize: CGSize
        
        if aspectRatio > 1 {
            newSize = CGSize(width: maxSize, height: maxSize / aspectRatio)
        } else {
            newSize = CGSize(width: maxSize * aspectRatio, height: maxSize)
        }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage ?? image
    }
}
