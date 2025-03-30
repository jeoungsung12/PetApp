//
//  RealmModel.swift
//  PetApp
//
//  Created by 정성윤 on 3/28/25.
//

import UIKit
import RealmSwift

final class RealmHomeEntity: Object {
    @Persisted(primaryKey: true) var id: String = ""
    @Persisted var animal: RealmHomeAnimalEntity?
    @Persisted var shelter: RealmHomeShelterEntity?
}

final class RealmHomeAnimalEntity: Object {
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

final class RealmUserInfo: Object {
    @Persisted(primaryKey: true) var name: String = ""
    @Persisted var image: String = ""
}

final class RecordRealmEntity: Object {
    @Persisted(primaryKey: true)
    var id: ObjectId
    
    @Persisted
    var location: String
    @Persisted
    var date: String
    @Persisted
    var imagePaths: List<String>
    @Persisted
    var title: String
    @Persisted
    var subTitle: String
    
    convenience init(
        location: String,
        date: String,
        imagePaths: [String],
        title: String,
        subTitle: String
    ) {
        self.init()
        self.id = ObjectId()
        self.location = location
        self.imagePaths.append(objectsIn: imagePaths)
        self.date = date
        self.title = title
        self.subTitle = subTitle
    }
}
