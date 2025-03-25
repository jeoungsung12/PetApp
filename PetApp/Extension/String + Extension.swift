//
//  String + Extension.swift
//  PetApp
//
//  Created by 정성윤 on 3/24/25.
//

import Foundation

extension String {
    
    //TODO: Type
    func toDate(format: String = "yyyy-MM-dd") -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.date(from: self) ?? Date()
    }
}
