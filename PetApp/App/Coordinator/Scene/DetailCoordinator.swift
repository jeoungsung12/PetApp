//
//  DetailCoordinator.swift
//  PetApp
//
//  Created by 정성윤 on 5/3/25.


import UIKit

final class DetailCoordinator: Coordinator, DetailCoordinating {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
    }
    
    func showDetail(with entity: HomeEntity, from sourceCoordinator: Coordinator) {
        if let detailVM = DIContainer.shared.resolveFactory(type: DetailViewModel.self, entity: entity) {
            let detailVC = DetailViewController(viewModel: detailVM)
            detailVC.coordinator = self
            
            if let homeCoord = sourceCoordinator as? HomeCoordinator {
                detailVC.sourceCoordinator = .home
                homeCoord.navigationController.pushViewController(detailVC, animated: true)
            } else if let chatCoord = sourceCoordinator as? ChatCoordinator {
                detailVC.sourceCoordinator = .chat
                chatCoord.navigationController.pushViewController(detailVC, animated: true)
            } else if let myPageCoord = sourceCoordinator as? MyPageCoordinator {
                detailVC.sourceCoordinator = .mypage
                myPageCoord.navigationController.pushViewController(detailVC, animated: true)
            }
        }
    }
    
    func closeDetail() {
    }
}
