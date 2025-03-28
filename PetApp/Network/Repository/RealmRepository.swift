//
//  RealmRepository.swift
//  PetApp
//
//  Created by 정성윤 on 3/28/25.
//
import Foundation
import RealmSwift

struct RealmEntity {
    var bool: Bool
    var message: String
    
    enum RealmType {
        case add
        case delete
        case error
        
        var description: String {
            switch self {
            case .add:
                "관심 등록 되었습니다!"
            case .delete:
                "관심 해제 되었습니다!"
            case .error:
                "실패! 잠시후 다시 시도해 보세요"
            }
        }
    }
}

struct UserInfo {
    let name: String
    let image: String
}

class RealmUserInfo: Object {
    @Persisted(primaryKey: true) var name: String = ""
    @Persisted var image: String = ""
}

protocol UserRepositoryType {
    func saveLikedHomeEntity(_ homeEntity: HomeEntity)
    func removeLikedHomeEntity(id: String)
    func getAllLikedHomeEntities() -> [HomeEntity]
    func isLiked(id: String) -> Bool
    
    
    func saveUserInfo(_ userInfo: UserInfo)
    func getUserInfo() -> UserInfo?
    func updateUserInfo(_ userInfo: UserInfo)
    func deleteUserInfo()
}

final class RealmUserRepository: UserRepositoryType {
    static let shared: UserRepositoryType = RealmUserRepository()
    private let realm = try! Realm()
    
    private init() {}
    
    private func toRealmEntity(_ homeEntity: HomeEntity) -> RealmHomeEntity {
        let realmHomeEntity = RealmHomeEntity()
        
        let animal = RealmHomeAnimalEntity()
        animal.id = homeEntity.animal.id
        animal.name = homeEntity.animal.name
        animal.descriptionText = homeEntity.animal.description
        animal.color = homeEntity.animal.color
        animal.age = homeEntity.animal.age
        animal.weight = homeEntity.animal.weight
        animal.thumbImage = homeEntity.animal.thumbImage
        animal.fullImage = homeEntity.animal.fullImage
        animal.state = homeEntity.animal.state
        animal.gender = homeEntity.animal.gender
        animal.neut = homeEntity.animal.neut
        
        let shelter = RealmHomeShelterEntity()
        shelter.name = homeEntity.shelter.name
        shelter.number = homeEntity.shelter.number
        shelter.address = homeEntity.shelter.address
        shelter.discplc = homeEntity.shelter.discplc
        shelter.beginDate = homeEntity.shelter.beginDate
        shelter.endDate = homeEntity.shelter.endDate
        shelter.lon = homeEntity.shelter.lon
        shelter.lat = homeEntity.shelter.lat
        
        realmHomeEntity.animal = animal
        realmHomeEntity.shelter = shelter
        
        return realmHomeEntity
    }
    
    private func toHomeEntity(_ realmEntity: RealmHomeEntity) -> HomeEntity {
        let animal = HomeAnimalEntity(
            id: realmEntity.animal?.id ?? "",
            name: realmEntity.animal?.name ?? "",
            description: realmEntity.animal?.descriptionText ?? "",
            color: realmEntity.animal?.color ?? "",
            age: realmEntity.animal?.age ?? "",
            weight: realmEntity.animal?.weight ?? "",
            thumbImage: realmEntity.animal?.thumbImage ?? "",
            fullImage: realmEntity.animal?.fullImage ?? "",
            state: realmEntity.animal?.state ?? "",
            gender: realmEntity.animal?.gender ?? "",
            neut: realmEntity.animal?.neut ?? ""
        )
        
        let shelter = HomeShelterEntity(
            name: realmEntity.shelter?.name ?? "",
            number: realmEntity.shelter?.number ?? "",
            address: realmEntity.shelter?.address ?? "",
            discplc: realmEntity.shelter?.discplc ?? "",
            beginDate: realmEntity.shelter?.beginDate ?? "",
            endDate: realmEntity.shelter?.endDate ?? "",
            lon: realmEntity.shelter?.lon ?? "",
            lat: realmEntity.shelter?.lat ?? ""
        )
        
        return HomeEntity(animal: animal, shelter: shelter)
    }
    
    func saveLikedHomeEntity(_ homeEntity: HomeEntity) {
        let realmEntity = toRealmEntity(homeEntity)
        try! realm.write {
            realm.add(realmEntity, update: .modified)
        }
    }
    
    func removeLikedHomeEntity(id: String) {
        guard let entity = realm.object(ofType: RealmHomeAnimalEntity.self, forPrimaryKey: id) else { return }
        try! realm.write {
            if let homeEntity = realm.objects(RealmHomeEntity.self).filter("animal.id == %@", id).first {
                realm.delete(homeEntity)
            }
        }
    }
    
    func getAllLikedHomeEntities() -> [HomeEntity] {
        let realmEntities = realm.objects(RealmHomeEntity.self)
        return realmEntities.map { toHomeEntity($0) }
    }
    
    func isLiked(id: String) -> Bool {
        return realm.object(ofType: RealmHomeAnimalEntity.self, forPrimaryKey: id) != nil
    }
}

extension RealmUserRepository {
    
    func saveUserInfo(_ userInfo: UserInfo) {
        let realmUserInfo = toRealmUserInfo(userInfo)
        try! realm.write {
            realm.add(realmUserInfo, update: .modified)
        }
    }
    
    func getUserInfo() -> UserInfo? {
        guard let realmUserInfo = realm.objects(RealmUserInfo.self).first else { return nil }
        return toUserInfo(realmUserInfo)
    }
    
    func updateUserInfo(_ userInfo: UserInfo) {
        try! realm.write {
            let realmUserInfo = toRealmUserInfo(userInfo)
            realm.add(realmUserInfo, update: .modified)
        }
    }
    
    func deleteUserInfo() {
        try! realm.write {
            realm.delete(realm.objects(RealmUserInfo.self))
        }
    }
    
    private func toRealmUserInfo(_ userInfo: UserInfo) -> RealmUserInfo {
        let realmUserInfo = RealmUserInfo()
        realmUserInfo.name = userInfo.name
        realmUserInfo.image = userInfo.image
        return realmUserInfo
    }
    
    private func toUserInfo(_ realmUserInfo: RealmUserInfo) -> UserInfo {
        return UserInfo(
            name: realmUserInfo.name,
            image: realmUserInfo.image
        )
    }
}
