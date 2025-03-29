//
//  RealmModel.swift
//  PetApp
//
//  Created by 정성윤 on 3/28/25.
//

import Foundation
import RealmSwift

final class RealmHomeEntity: Object {
    @Persisted(primaryKey: true) var id: String = ""
    @Persisted var animal: RealmHomeAnimalEntity?
    @Persisted var shelter: RealmHomeShelterEntity?
}

final class RealmHomeAnimalEntity: Object {
    @Persisted(primaryKey: true) var id: String = ""
    @Persisted var name: String = ""
    @Persisted var descriptionText: String = ""
    @Persisted var color: String = ""
    @Persisted var age: String = ""
    @Persisted var weight: String = ""
    @Persisted var thumbImage: String = ""
    @Persisted var fullImage: String = ""
    @Persisted var state: String = ""
    @Persisted var gender: String = ""
    @Persisted var neut: String = ""
}

final class RealmHomeShelterEntity: Object {
    @Persisted var name: String = ""
    @Persisted var number: String = ""
    @Persisted var address: String = ""
    @Persisted var discplc: String = ""
    @Persisted var beginDate: String = ""
    @Persisted var endDate: String = ""
    @Persisted var lon: String = ""
    @Persisted var lat: String = ""
}

struct UserInfo {
    let name: String
    let image: String
}

class RealmUserInfo: Object {
    @Persisted(primaryKey: true) var name: String = ""
    @Persisted var image: String = ""
}
