//
//  MainCoordinator.swift
//  PetApp
//
//  Created by 정성윤 on 5/3/25.
//

import UIKit

final class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?
    
    private lazy var detailCoordinator: DetailCoordinator = {
        let coordinator = DetailCoordinator(navigationController: UINavigationController())
        coordinator.parentCoordinator = self
        return coordinator
    }()
    
    private lazy var mapCoordinator: MapCoordinator = {
        let coordinator = MapCoordinator(navigationController: UINavigationController())
        coordinator.parentCoordinator = self
        return coordinator
    }()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let tabBarController = TabBarController(
            locationManager: DIContainer.shared.resolve(type: LocationRepositoryType.self)!
        )
        tabBarController.coordinator = self
        
        setupTabBarCoordinators(tabBarController: tabBarController)
        navigationController.viewControllers = [tabBarController]
        
        childCoordinators.append(detailCoordinator)
        childCoordinators.append(mapCoordinator)
    }
    
    private func setupTabBarCoordinators(tabBarController: TabBarController) {
        let homeNavigationController = UINavigationController()
        let homeCoordinator = HomeCoordinator(navigationController: homeNavigationController)
        homeCoordinator.detailCoordinator = detailCoordinator
        homeCoordinator.mapCoordinator = mapCoordinator
        homeCoordinator.parentCoordinator = self
        homeCoordinator.start()
        childCoordinators.append(homeCoordinator)
        
        let recordNavigationController = UINavigationController()
        let recordCoordinator = RecordCoordinator(navigationController: recordNavigationController)
        recordCoordinator.parentCoordinator = self
        recordCoordinator.start()
        childCoordinators.append(recordCoordinator)
        
        let chatNavigationController = UINavigationController()
        let chatCoordinator = ChatCoordinator(navigationController: chatNavigationController)
        chatCoordinator.detailCoordinator = detailCoordinator
        chatCoordinator.parentCoordinator = self
        chatCoordinator.start()
        childCoordinators.append(chatCoordinator)
        
        let playerNavigationController = UINavigationController()
        let playerCoordinator = PlayerCoordinator(navigationController: playerNavigationController)
        playerCoordinator.parentCoordinator = self
        playerCoordinator.start()
        childCoordinators.append(playerCoordinator)
        
        let myPageNavigationController = UINavigationController()
        let myPageCoordinator = MyPageCoordinator(navigationController: myPageNavigationController)
        myPageCoordinator.detailCoordinator = detailCoordinator
        myPageCoordinator.parentCoordinator = self
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
    
    func navigateToLogin() {
        guard let appCoordinator = parentCoordinator as? AppCoordinator else { return }
        appCoordinator.childCoordinators.removeAll()
        appCoordinator.showLogin()
        finish()
    }
}
