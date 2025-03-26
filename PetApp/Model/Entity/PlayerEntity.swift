//
//  PlayerEntity.swift
//  PetApp
//
//  Created by 정성윤 on 3/25/25.
//

import Foundation

struct PlayerEntity {
    let name: String
    let date: String
    let species: String
    let sex: String
    let age: String
    let weight: String
    let status: String
    let videoURL: String
    let shelter: String
}

extension PlayerResponseDTO {
    
    enum AdoptionState: String {
        case N
        case P
        case C
    }
    
    enum ProtectState: String {
        case N
        case C
    }
    
    func stateToStatus(_ AType: String, _ PType: String) -> String {
        guard let adoptionState = AdoptionState(rawValue: AType),
              let protectState = ProtectState(rawValue: PType) else {
            return "알 수 없는 상태"
        }
        
        switch (adoptionState, protectState) {
        case (.N, .N):
            return "입양 대기 (센터 보호 중)"
        case (.N, .C):
            return "입양 대기 (임시 보호 중)"
        case (.P, .N):
            return "입양 진행 중 (센터 보호 중)"
        case (.P, .C):
            return "입양 진행 중 (임시 보호 중)"
        case (.C, .N):
            return "입양 완료 (센터 보호 종료)"
        case (.C, .C):
            return "입양 완료 (임시 보호 종료)"
        }
    }
    
    func toEntity() -> [PlayerEntity] {
        return tbAdpWaitAnimalView.row.map {
            return PlayerEntity(
                name: $0.breeds,
                date: $0.entrncDate,
                species: $0.breeds,
                sex: $0.sexdstn,
                age: $0.age,
                weight: String($0.bdwgh),
                status: stateToStatus($0.adpSttus, $0.tmprPrtcSttus),
                videoURL: $0.intrcnMVPURL,
                shelter: "서울동묵복지지원센터 " + $0.nm
            )
        }
    }
}
