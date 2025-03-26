//
//  PlayerResponseDTO.swift
//  PetApp
//
//  Created by 정성윤 on 3/25/25.
//

import Foundation

struct PlayerResponseDTO: Decodable {
    let tbAdpWaitAnimalView: TBAdpWaitAnimalView
    
    enum CodingKeys: String, CodingKey {
        case tbAdpWaitAnimalView = "TbAdpWaitAnimalView"
    }
}

struct TBAdpWaitAnimalView: Decodable {
    let listTotalCount: Int
    let row: [TBARow]
    
    enum CodingKeys: String, CodingKey {
        case listTotalCount = "list_total_count"
        case row
    }
}

struct TBARow: Decodable {
    let animalNo, nm, entrncDate, spcs: String
    let breeds, sexdstn, age: String
    let bdwgh: Double
    let adpSttus, tmprPrtcSttus: String
    let intrcnMVPURL: String
    
    enum CodingKeys: String, CodingKey {
        case animalNo = "ANIMAL_NO"
        case nm = "NM"
        case entrncDate = "ENTRNC_DATE"
        case spcs = "SPCS"
        case breeds = "BREEDS"
        case sexdstn = "SEXDSTN"
        case age = "AGE"
        case bdwgh = "BDWGH"
        case adpSttus = "ADP_STTUS"
        case tmprPrtcSttus = "TMPR_PRTC_STTUS"
        case intrcnMVPURL = "INTRCN_MVP_URL"
    }
}
