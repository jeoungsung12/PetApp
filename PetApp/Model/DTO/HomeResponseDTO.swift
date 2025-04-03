//
//  HomeResponseDTO.swift
//  PetApp
//
//  Created by 정성윤 on 3/24/25.
//

import Foundation

struct HomeResponseDTO: Decodable {
    let response: HomeResponse
}

struct HomeResponse: Decodable {
    let body: HomeBody?
    
    struct HomeBody: Decodable {
        let items: HomeItems
    }
    
    struct HomeItems: Decodable {
        let item: [HomeItem]
    }
    
    struct HomeItem: Codable {
        let desertionNo, happenDt, happenPlace, kindFullNm: String?
        let upKindCD, upKindNm, kindCD, kindNm: String?
        let colorCD, age, weight, noticeNo: String?
        let noticeSdt, noticeEdt: String?
        let popfile1, popfile2: String?
        let processState, sexCD, neuterYn, specialMark: String?
        let careRegNo, careNm, careTel, careAddr: String?
        let careOwnerNm, orgNm, updTm: String?
        
        enum CodingKeys: String, CodingKey {
            case desertionNo, happenDt, happenPlace, kindFullNm
            case upKindCD = "upKindCd"
            case upKindNm
            case kindCD = "kindCd"
            case kindNm
            case colorCD = "colorCd"
            case age, weight, noticeNo, noticeSdt, noticeEdt, popfile1, popfile2, processState
            case sexCD = "sexCd"
            case neuterYn, specialMark, careRegNo, careNm, careTel, careAddr, careOwnerNm, orgNm, updTm
        }
    }
}
