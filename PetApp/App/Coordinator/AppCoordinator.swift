//
//  AppCoordinator.swift
//  PetApp
//
//  Created by 정성윤 on 4/7/25.
//

import UIKit

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let userInfo = RealmRepository.shared.getUserInfo()
        
        if userInfo != nil {
            showMainTabBar()
        } else {
            showLogin()
        }
    }
    
    private func showLogin() {
        let loginCoordinator = ProfileCoordinator(navigationController: navigationController)
        childCoordinators.append(loginCoordinator)
        loginCoordinator.delegate = self
        loginCoordinator.start()
    }
    
    private func showMainTabBar() {
        let tabBarController = TabBarController()
        tabBarController.coordinator = self
        
        setupTabBarCoordinators(tabBarController: tabBarController)
        navigationController.viewControllers = [tabBarController]
    }
    
    private func setupTabBarCoordinators(tabBarController: TabBarController) {
        let homeNavigationController = UINavigationController()
        let homeCoordinator = HomeCoordinator(navigationController: homeNavigationController)
        homeCoordinator.start()
        childCoordinators.append(homeCoordinator)
        
        let recordNavigationController = UINavigationController()
        let recordCoordinator = RecordCoordinator(navigationController: recordNavigationController)
        recordCoordinator.start()
        childCoordinators.append(recordCoordinator)
        
        let chatNavigationController = UINavigationController()
        let chatCoordinator = ChatCoordinator(navigationController: chatNavigationController)
        chatCoordinator.start()
        childCoordinators.append(chatCoordinator)
        
        let playerNavigationController = UINavigationController()
        let playerCoordinator = PlayerCoordinator(navigationController: playerNavigationController)
        playerCoordinator.start()
        childCoordinators.append(playerCoordinator)
        
        let myPageNavigationController = UINavigationController()
        let myPageCoordinator = MyPageCoordinator(navigationController: myPageNavigationController)
        myPageCoordinator.start()
        childCoordinators.append(myPageCoordinator)
        
        tabBarController.setViewControllers([
            homeNavigationController,
            recordNavigationController,
            chatNavigationController,
            playerNavigationController,
            myPageNavigationController
        ], animated: false)
        
        if let items = tabBarController.tabBar.items {
            items[0].image = .footPrintImage
            items[0].title = "홈"
            
            items[1].image = .listImage
            items[1].title = "기록"
            
            items[2].image = .bubbleImage
            items[2].title = "채팅"
            
            items[3].image = .playImage
            items[3].title = "영상"
            
            items[4].image = .personImage
            items[4].title = "프로필"
        }
        
        tabBarController.tabBar.tintColor = .point
    }
}

extension AppCoordinator: ProfileCoordinatorDelegate {
    func didFinishProfile() {
        childCoordinators.removeAll { $0 is ProfileCoordinator }
        showMainTabBar()
    }
}
