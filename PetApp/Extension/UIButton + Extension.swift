//
//  UIButton + Extension.swift
//  PetApp
//
//  Created by 정성윤 on 3/28/25.
//

import UIKit

extension UIButton {
    func setBorder(_ width: CGFloat = 2, _ radius: CGFloat = 20, _ color: UIColor = .point) {
        self.clipsToBounds = true
        self.layer.borderWidth = width
        self.layer.cornerRadius = radius
        self.layer.borderColor = color.cgColor
    }
}
