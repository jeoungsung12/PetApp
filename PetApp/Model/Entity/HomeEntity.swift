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
    let gender: String
    let neut: String
}

struct HomeShelterEntity {
    let name: String
    let number: String
    let address: String
    let discplc: String
    let beginDate: String
    let endDate: String
}

extension HomeResponseDTO {
    func toEntity() -> [HomeEntity] {
        return response.body?.items.item.map {
            return HomeEntity(
                animal: HomeAnimalEntity(
                    id: $0.desertionNo ?? "\(UUID())",
                    name: $0.kindNm ?? "",
                    description: $0.specialMark ?? "",
                    color: $0.colorCD ?? "",
                    age: $0.age ?? "",
                    weight: $0.weight ?? "",
                    thumbImage: $0.popfile1 ?? "",
                    fullImage: $0.popfile2 ?? "",
                    state: $0.processState ?? "",
                    gender: ($0.sexCD == "M" ? "🚹" : "🚺") ?? "",
                    neut: ($0.neuterYn == "Y" ? "⭕️" : "❌") ?? ""
                ),
                shelter: HomeShelterEntity(
                    name: $0.careNm ?? "-",
                    number: $0.careTel ?? "-",
                    address: $0.careAddr ?? "-",
                    discplc: $0.happenPlace ?? "",
                    beginDate: $0.noticeSdt ?? "",
                    endDate: $0.noticeEdt ?? ""
                )
            )
        } ?? []
    }
}
