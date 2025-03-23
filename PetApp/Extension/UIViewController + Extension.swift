//
//  UIViewController + Extension.swift
//  PetApp
//
//  Created by 정성윤 on 3/22/25.
//

import UIKit

extension UIViewController {
    
    func setNavigation(
        title: String? = nil,
        backTitle: String? = nil,
        backImage: UIImage? = .arrowLeft,
        color: UIColor = .point
    ) {
        guard let navigationBar = navigationController?.navigationBar else { return }
        
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "logo")
        let titleItem = UIBarButtonItem(customView: logoImageView)
        self.navigationItem.leftBarButtonItem = titleItem
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)
        appearance.titleTextAttributes = [.foregroundColor: color]
        appearance.shadowColor = nil
        
        navigationBar.tintColor = color
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
}
