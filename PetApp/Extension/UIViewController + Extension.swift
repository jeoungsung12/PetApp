//
//  UIViewController + Extension.swift
//  PetApp
//
//  Created by 정성윤 on 3/22/25.
//

import UIKit

extension UIViewController {
    
    func setNavigation(
        logo: Bool = false,
        title: String? = nil,
        backTitle: String? = nil,
        backImage: UIImage? = .arrowLeft,
        color: UIColor = .white
    ) {
        guard let navigationBar = navigationController?.navigationBar else { return }
        
        if logo {
            let logoImageView = UIImageView()
            logoImageView.image = UIImage(named: "logo")
            let titleItem = UIBarButtonItem(customView: logoImageView)
            self.navigationItem.leftBarButtonItem = titleItem
        }
        
        let back = UIBarButtonItem(title: backTitle, style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = back
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = color
        appearance.shadowColor = nil
        
        navigationBar.tintColor = .point
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
}
