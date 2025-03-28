//
//  HospitalResponseDTO.swift
//  PetApp
//
//  Created by 정성윤 on 3/27/25.
//

import Foundation

struct HospitalResponseDTO: Decodable {
    let Animalhosptl: [AnimalhosptlDTO]
    
    struct AnimalhosptlDTO: Decodable {
        let row: [HospitalRowDTO]?
    }
}

struct HospitalRowDTO: Decodable {
    let sigunNm, sigunCD, bizplcNm, licensgDe: String
    let stockrsDutyDivNm, refineLotnoAddr: String
    let refineWgs84Logt, refineWgs84Lat: String?
    let refineZipCD, refineRoadnmAddr, locplcFacltTelno: String?
    
    enum CodingKeys: String, CodingKey {
        case sigunNm = "SIGUN_NM"
        case sigunCD = "SIGUN_CD"
        case bizplcNm = "BIZPLC_NM"
        case licensgDe = "LICENSG_DE"
        case stockrsDutyDivNm = "STOCKRS_DUTY_DIV_NM"
        case locplcFacltTelno = "LOCPLC_FACLT_TELNO"
        case refineLotnoAddr = "REFINE_LOTNO_ADDR"
        case refineRoadnmAddr = "REFINE_ROADNM_ADDR"
        case refineZipCD = "REFINE_ZIP_CD"
        case refineWgs84Logt = "REFINE_WGS84_LOGT"
        case refineWgs84Lat = "REFINE_WGS84_LAT"
    }
}
