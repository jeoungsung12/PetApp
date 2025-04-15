//
//  AnimalRouter.swift
//  PetApp
//
//  Created by 정성윤 on 4/15/25.
//

import Foundation
import Alamofire

enum AnimalError: Error, LocalizedError {
    case missingRequiredValue
    case invalidAuthKey
    case dataRequestLimitExceeded
    case invalidIndexType
    case serviceNotFound
    case dailyTrafficLimitExceeded
    case serverError
    case databaseConnectionError
    case sqlSyntaxError
    case authKeyRestricted
    case noDataAvailable
    
    var errorDescription: String? {
        switch self {
        case .missingRequiredValue, .invalidAuthKey, .dataRequestLimitExceeded,
                .invalidIndexType, .dailyTrafficLimitExceeded, .authKeyRestricted:
            return "비정상적인 접근입니다."
        case .serviceNotFound, .sqlSyntaxError, .noDataAvailable:
            return "페이지를 찾을 수 없습니다."
        case .serverError:
            return "서버에 문제가 생겼습니다."
        case .databaseConnectionError:
            return "정보를 가져올 수 없습니다."
        }
    }
    
    static func mapToError(statusCode: Int) -> AnimalError {
        switch (statusCode) {
        case (300):
            return .missingRequiredValue
        case (290):
            return .invalidAuthKey
        case (336):
            return .dataRequestLimitExceeded
        case (333):
            return .invalidIndexType
        case (310):
            return .serviceNotFound
        case (337):
            return .dailyTrafficLimitExceeded
        case (500):
            return .serverError
        case (600):
            return .databaseConnectionError
        case (601):
            return .sqlSyntaxError
        case (300):
            return .authKeyRestricted
        case (200):
            return .noDataAvailable
        default:
            return .serverError
        }
    }
}

enum AnimalRouter {
    case getAnimal(page: Int, regionCode: String?)
    case getShelter
    case getVideo(startPage: Int, endPage: Int)
}

extension AnimalRouter: Router {
    static var feedBackURL = "https://forms.gle/jE8o3EfUiAK7cTgR7"
    var endpoint: String {
        return baseURL + path
    }
    
    var baseURL: String {
        switch self {
        case .getVideo:
            return "http://openapi.seoul.go.kr:8088/"
        default:
            return "https://apis.data.go.kr/1543061/"
        }
    }
    
    var path: String {
        switch self {
        case .getAnimal(let page, let regionCode):
            if let regionCode = regionCode {
                return "abandonmentPublicService_v2/abandonmentPublic_v2?serviceKey=\(APIKey.animal.rawValue)&pageNo=\(page)&numOfRows=20&upr_cd=\(regionCode)&_type=json"
            } else {
                return "abandonmentPublicService_v2/abandonmentPublic_v2?serviceKey=\(APIKey.animal.rawValue)&pageNo=\(page)&numOfRows=20&_type=json"
            }
        case .getShelter:
            return "animalShelterSrvc_v2/shelterInfo_v2?serviceKey=\(APIKey.animal.rawValue)&numOfRows=1000&pageNo=1&_type=json"
        case .getVideo(let startPage, let endPage):
            return "\(APIKey.video.rawValue)/json/TbAdpWaitAnimalView/\(startPage)/\(endPage)"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: HTTPHeaders {
        return [
            "Content-Type":"application/json"
        ]
    }
    
    var params: Parameters {
        return [:]
    }
    
    var encoding: (any ParameterEncoding)? {
        nil
    }
    
    
}

