//
//  HomeEntity.swift
//  PetApp
//
//  Created by 정성윤 on 3/24/25.
//

import Foundation

struct HomeEntity {
    let animal: HomeAnimalEntity
    let shelter: HomeShelterEntity
}

struct HomeAnimalEntity {
    let id: String
    let name: String
    let description: String
    let color: String
    let age: String
    let weight: String
    let thumbImage: String
    let fullImage: String
    let state: String
    let sex: String
    let neut: String
}

struct HomeShelterEntity {
    let name: String
    let number: String
    let address: String
    let discplc: String
    let beginDate: String
    let endDate: String
    let lon: String
    let lat: String
}

extension HomeResponseDTO {
    func toEntity() -> [HomeEntity] {
        return (abdmAnimalProtect[1].row ?? []).map {
            HomeEntity(
                animal: HomeAnimalEntity(
                    id: $0.abdmIdntfyNo,
                    name: $0.speciesNm,
                    description: $0.sfetrInfo,
                    color: $0.colorNm,
                    age: $0.ageInfo,
                    weight: $0.bdwghInfo,
                    thumbImage: $0.thumbImageCours,
                    fullImage: $0.imageCours,
                    state: $0.stateNm,
                    sex: ($0.sexNm == "M") ? "🚹" : "🚺",
                    neut: ($0.neutYn == "N") ? "❌" : "⭕️"
                ),
                shelter: HomeShelterEntity(
                    name: $0.shterNm,
                    number: $0.shterTelno,
                    address: $0.protectPLC,
                    discplc: $0.discvryPLCInfo,
                    beginDate: $0.pblancBeginDe,
                    endDate: $0.pblancEndDe,
                    lon: $0.refineWgs84Logt,
                    lat: $0.refineWgs84Lat
                )
            )
        }
    }
}
