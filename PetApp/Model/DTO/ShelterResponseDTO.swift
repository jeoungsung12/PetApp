//
//  ShelterResponseDTO.swift
//  PetApp
//
//  Created by 정성윤 on 3/27/25.
//

import Foundation

struct ShelterResponseDTO: Decodable {
    let OrganicAnimalProtectionFacilit: [AnimalProtectionDTO]
    
    struct AnimalProtectionDTO: Decodable {
        let row: [ShelterRowDTO]?
    }
}

struct ShelterRowDTO: Decodable {
    let sumYy, sigunNm, sigunCD, entrpsNm: String
    let reprsntvNm: String
    let aceptncAbltyCnt: Int
    let entrpsTelno, contractPerd: String
    let corprAnimalHosptlDtls, rmMatr: String?
    let refineLotnoAddr, refineRoadnmAddr, refineZipCD, refineWgs84Logt: String
    let refineWgs84Lat: String
    
    enum CodingKeys: String, CodingKey {
        case sumYy = "SUM_YY"
        case sigunNm = "SIGUN_NM"
        case sigunCD = "SIGUN_CD"
        case entrpsNm = "ENTRPS_NM"
        case reprsntvNm = "REPRSNTV_NM"
        case aceptncAbltyCnt = "ACEPTNC_ABLTY_CNT"
        case entrpsTelno = "ENTRPS_TELNO"
        case contractPerd = "CONTRACT_PERD"
        case corprAnimalHosptlDtls = "CORPR_ANIMAL_HOSPTL_DTLS"
        case rmMatr = "RM_MATR"
        case refineLotnoAddr = "REFINE_LOTNO_ADDR"
        case refineRoadnmAddr = "REFINE_ROADNM_ADDR"
        case refineZipCD = "REFINE_ZIP_CD"
        case refineWgs84Logt = "REFINE_WGS84_LOGT"
        case refineWgs84Lat = "REFINE_WGS84_LAT"
    }
}
