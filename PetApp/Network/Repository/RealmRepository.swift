//
//  RealmRepository.swift
//  PetApp
//
//  Created by 정성윤 on 3/28/25.
//
import Foundation
import RealmSwift

protocol RealmRepositoryType {
    func saveLikedHomeEntity(_ homeEntity: HomeEntity)
    func removeLikedHomeEntity(id: String)
    func removeAllLikedEntity()
    func getAllLikedHomeEntities() -> [HomeEntity]
    func isLiked(id: String) -> Bool
    
    func saveUserInfo(_ userInfo: UserInfo)
    func getUserInfo() -> UserInfo?
    func deleteUserInfo()
    
    func saveRecord(_ record: RecordRealmEntity) -> Bool
    func removeRecord(id: String) -> Bool
    func getAllRecords() -> [RecordRealmEntity]
    func removeAllRecords()
}

final class RealmRepository: RealmRepositoryType {
    static let shared: RealmRepositoryType = RealmRepository()
    private let realm = try! Realm()
    
    private init() {}
    
    func saveRecord(_ record: RecordRealmEntity) -> Bool {
        do {
            try realm.write {
                realm.add(record, update: .modified)
            }
            return true
        } catch {
            return false
        }
    }
    
    func removeRecord(id: String) -> Bool {
        guard let record = realm.object(ofType: RecordRealmEntity.self, forPrimaryKey: id) else {
            print("기록 삭제 실패")
            return false
        }
        do {
            try realm.write {
                realm.delete(record)
            }
            return true
        } catch {
            return false
        }
    }
    
    func removeAllRecords() {
        do {
            try realm.write {
                let allRecords = realm.objects(RecordRealmEntity.self)
                realm.delete(allRecords)
            }
        } catch {
            print("모든 기록 삭제 실패")
        }
    }
    
    func getAllRecords() -> [RecordRealmEntity] {
        let records = realm.objects(RecordRealmEntity.self)
        return Array(records)
    }
    
}

extension RealmRepository {
    
    private func toRealmEntity(_ homeEntity: HomeEntity) -> RealmHomeEntity {
        let realmHomeEntity = RealmHomeEntity()
        realmHomeEntity.id = homeEntity.animal.id
        
        let animal = RealmHomeAnimalEntity()
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
        
        realmHomeEntity.animal = animal
        realmHomeEntity.shelter = shelter
        
        return realmHomeEntity
    }
    
    private func toHomeEntity(_ realmEntity: RealmHomeEntity) -> HomeEntity {
        let animal = HomeAnimalEntity(
            id: realmEntity.id,
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
            endDate: realmEntity.shelter?.endDate ?? ""
        )
        
        return HomeEntity(animal: animal, shelter: shelter)
    }
    
    func saveLikedHomeEntity(_ homeEntity: HomeEntity) {
        do {
            let realmEntity = toRealmEntity(homeEntity)
            try realm.write {
                realm.add(realmEntity, update: .modified)
            }
        } catch {
            print("관심등록 실패 \(error)")
        }
    }
    
    func removeAllLikedEntity() {
        do {
            try realm.write {
                let allLikedEntities = realm.objects(RealmHomeEntity.self)
                realm.delete(allLikedEntities)
            }
        } catch {
            print("모든 좋아요 엔티티 삭제 실패: \(error)")
        }
    }
    
    func removeLikedHomeEntity(id: String) {
        do {
            try realm.write {
                if let homeEntity = realm.object(ofType: RealmHomeEntity.self, forPrimaryKey: id) {
                    realm.delete(homeEntity)
                }
            }
        } catch {
            print("관심 삭제 실패")
        }
    }
    
    func getAllLikedHomeEntities() -> [HomeEntity] {
        let realmEntities = realm.objects(RealmHomeEntity.self)
        return realmEntities.map { toHomeEntity($0) }
    }
    
    func isLiked(id: String) -> Bool {
        return realm.object(ofType: RealmHomeEntity.self, forPrimaryKey: id) != nil
    }
}

extension RealmRepository {
    
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
    
    func saveUserInfo(_ userInfo: UserInfo) {
        do {
            let realmUserInfo = toRealmUserInfo(userInfo)
            deleteUserInfo()
            try realm.write {
                realm.add(realmUserInfo)
            }
        } catch {
            print("사용자 정보 저장 실패")
        }
    }
    
    func getUserInfo() -> UserInfo? {
        guard let realmUserInfo = realm.objects(RealmUserInfo.self).first else { return nil }
        return toUserInfo(realmUserInfo)
    }
    
    func deleteUserInfo() {
        do {
            try realm.write {
                realm.delete(realm.objects(RealmUserInfo.self))
            }
        } catch {
            print("사용자 정보 삭제 실패")
        }
    }
}
