//
//  HomeResponseDTO.swift
//  PetApp
//
//  Created by 정성윤 on 3/24/25.
//

import Foundation

struct HomeResponseDTO: Decodable {
    let AbdmAnimalProtect: [AbdmAnimalProtectDTO]
    
    struct AbdmAnimalProtectDTO: Decodable {
        let row: [AbdmRow]
        
        struct AbdmRow: Decodable {
            let sigunCD, sigunNm, abdmIdntfyNo: String
            let thumbImageCours: String
            let receptDe, discvryPLCInfo, speciesNm, colorNm: String
            let ageInfo, bdwghInfo, pblancIdntfyNo, pblancBeginDe: String
            let pblancEndDe: String
            let imageCours: String
            let stateNm, sexNm, neutYn, sfetrInfo: String
            let shterNm, shterTelno, protectPLC, jurisdInstNm: String
            let chrgpsnNm, chrgpsnContctNo, partclrMatr: Int?
            let refineLotnoAddr, refineRoadnmAddr, refineZipCD, refineWgs84Logt: String
            let refineWgs84Lat: String
            
            enum CodingKeys: String, CodingKey {
                case sigunCD = "SIGUN_CD"
                case sigunNm = "SIGUN_NM"
                case abdmIdntfyNo = "ABDM_IDNTFY_NO"
                case thumbImageCours = "THUMB_IMAGE_COURS"
                case receptDe = "RECEPT_DE"
                case discvryPLCInfo = "DISCVRY_PLC_INFO"
                case speciesNm = "SPECIES_NM"
                case colorNm = "COLOR_NM"
                case ageInfo = "AGE_INFO"
                case bdwghInfo = "BDWGH_INFO"
                case pblancIdntfyNo = "PBLANC_IDNTFY_NO"
                case pblancBeginDe = "PBLANC_BEGIN_DE"
                case pblancEndDe = "PBLANC_END_DE"
                case imageCours = "IMAGE_COURS"
                case stateNm = "STATE_NM"
                case sexNm = "SEX_NM"
                case neutYn = "NEUT_YN"
                case sfetrInfo = "SFETR_INFO"
                case shterNm = "SHTER_NM"
                case shterTelno = "SHTER_TELNO"
                case protectPLC = "PROTECT_PLC"
                case jurisdInstNm = "JURISD_INST_NM"
                case chrgpsnNm = "CHRGPSN_NM"
                case chrgpsnContctNo = "CHRGPSN_CONTCT_NO"
                case partclrMatr = "PARTCLR_MATR"
                case refineLotnoAddr = "REFINE_LOTNO_ADDR"
                case refineRoadnmAddr = "REFINE_ROADNM_ADDR"
                case refineZipCD = "REFINE_ZIP_CD"
                case refineWgs84Logt = "REFINE_WGS84_LOGT"
                case refineWgs84Lat = "REFINE_WGS84_LAT"
            }
        }
    }
}
