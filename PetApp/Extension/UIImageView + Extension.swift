//
//  UIImageView + Extension.swift
//  PetApp
//
//  Created by 정성윤 on 3/28/25.
//

import UIKit

extension UIImageView {
    
    func setBorder(_ itemSelected: Bool = true, _ radius: CGFloat = 15) {
        self.clipsToBounds = true
        self.layer.borderWidth = itemSelected ? 3 : 1
        self.layer.cornerRadius = radius
        self.layer.borderColor = itemSelected ? UIColor.point.cgColor : UIColor.customLightGray.cgColor
    }
    
}
