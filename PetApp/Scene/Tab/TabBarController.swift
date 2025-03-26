//
//  TabBarViewController.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/25/25.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

}

extension TabBarController {
    
    private func configure() {
        let firstVC = UINavigationController(rootViewController: HomeViewController())
        let secondVC = UINavigationController(rootViewController: HomeViewController())
        let thirdVC = UINavigationController(rootViewController: HomeViewController())
        let forthVC = UINavigationController(rootViewController: PlayerViewController())
        let fifthVC = UINavigationController(rootViewController: HomeViewController())
        
        self.setViewControllers([firstVC, secondVC, thirdVC, forthVC, fifthVC], animated: true)
        guard let items = self.tabBar.items else { return }
        items[0].image = .footPrintImage
        items[1].image = .listImage
        items[2].image = .bubbleImage
        items[3].image = .playImage
        items[4].image = .personImage
        
        items[0].title = "홈"
        items[1].title = "기록"
        items[2].title = "채팅"
        items[3].title = "영상"
        items[4].title = "프로필"
           
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .customWhite
        self.tabBar.standardAppearance = appearance
//        self.tabBar.scrollEdgeAppearance = appearance
        
        self.selectedIndex = 0
        self.tabBar.tintColor = .point
        self.tabBar.unselectedItemTintColor = .customLightGray
    }
    
}
