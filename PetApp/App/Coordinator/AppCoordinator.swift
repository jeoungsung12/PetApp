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
    var parentCoordinator: Coordinator? = nil
    
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
    
    func showLogin() {
        navigationController.isNavigationBarHidden = false
        let loginCoordinator = ProfileCoordinator(navigationController: navigationController)
        loginCoordinator.parentCoordinator = self
        childCoordinators.append(loginCoordinator)
        loginCoordinator.start()
    }
    
    func showMainTabBar() {
        let mainCoordinator = MainCoordinator(navigationController: navigationController)
        mainCoordinator.parentCoordinator = self
        childCoordinators.append(mainCoordinator)
        mainCoordinator.start()
    }
}
