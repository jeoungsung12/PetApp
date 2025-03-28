//
//  MapEntity.swift
//  PetApp
//
//  Created by 정성윤 on 3/27/25.
//

import Foundation

struct MapEntity {
    let name: String
    let number: String
    let address: String
    let roadAddress: String
    let numAddress: String
    let lon: Double
    let lat: Double
}

extension ShelterResponseDTO {
    func toEntity() -> [MapEntity] {
        return (self.OrganicAnimalProtectionFacilit[1].row ?? []).map {
            MapEntity(
                name: $0.entrpsNm,
                number: $0.entrpsTelno,
                address: $0.refineLotnoAddr,
                roadAddress: $0.refineRoadnmAddr,
                numAddress: $0.refineZipCD,
                lon: Double($0.refineWgs84Logt) ?? 0.0,
                lat: Double($0.refineWgs84Lat) ?? 0.0
            )
        }
    }
}

extension HospitalResponseDTO {
    func toEntity() -> [MapEntity] {
        return (self.Animalhosptl[1].row ?? []).map {
            MapEntity(
                name: $0.bizplcNm,
                number: $0.locplcFacltTelno ?? "",
                address: $0.refineLotnoAddr,
                roadAddress: $0.refineRoadnmAddr ?? "",
                numAddress: $0.refineZipCD ?? "",
                lon: Double($0.refineWgs84Logt ?? "") ?? 0.0,
                lat: Double($0.refineWgs84Lat ?? "") ?? 0.0
            )
        }
    }
}
