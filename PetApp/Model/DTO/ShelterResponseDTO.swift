//
//  ShelterResponseDTO.swift
//  PetApp
//
//  Created by 정성윤 on 3/27/25.
//

import Foundation

struct ShelterResponseDTO: Decodable {
    let response: ShelterResponse
}

struct ShelterResponse: Decodable {
    let body: ShelterBody?
    
    
    struct ShelterBody: Decodable {
        let items: ShelterItems
        let numOfRows, pageNo, totalCount: Int
    }
    
    struct ShelterItems: Codable {
        let item: [ShelterItem]
    }
    
    struct ShelterItem: Codable {
        let careNm, careRegNo, orgNm, divisionNm: String?
        let saveTrgtAnimal, careAddr, jibunAddr: String?
        let lat, lng: Double?
        let dsignationDate, weekOprStime, weekOprEtime, closeDay: String?
        let vetPersonCnt, specsPersonCnt: Int?
        let careTel, dataStdDt: String?
    }
    
}
