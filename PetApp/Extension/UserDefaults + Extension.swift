//
//  UserDefaults + Extension.swift
//  PetApp
//
//  Created by 정성윤 on 4/23/25.
//

import Foundation

extension UserDefaults {
    
    static var groupShared: UserDefaults {
        let appGroupID = "group.Warala.SeSAC"
        return UserDefaults(suiteName: appGroupID)!
    }
}
