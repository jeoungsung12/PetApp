//
//  String + Extension.swift
//  PetApp
//
//  Created by 정성윤 on 3/24/25.
//

import UIKit

extension String {
    
    func toDate() -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        formatter.locale = Locale(identifier: "ko_KR")
        let endDate = formatter.date(from: self) ?? Date()
        let today = Date()
        let daysRemaining = Calendar.current.dateComponents([.day], from: today, to: endDate).day ?? 0
        return daysRemaining
    }
    
    static func currentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일 HH:mm:ss"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: Date())
    }
    
    static func saveImage(image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 1.0) else { return nil }
        
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let imagePath = documentDirectory.appendingPathComponent(UUID().uuidString + ".jpg")
        
        do {
            try data.write(to: imagePath)
            return imagePath.path
        } catch {
            return nil
        }
    }
}
