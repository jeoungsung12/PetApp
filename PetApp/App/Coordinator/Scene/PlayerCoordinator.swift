//
//  PlayerCoordinator.swift
//  PetApp
//
//  Created by 정성윤 on 4/8/25.
//
import UIKit

protocol PlayerCoordinatorDelegate: AnyObject {
    func playerCoordinatorDidFinish(_ coordinator: PlayerCoordinator)
}

final class PlayerCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var delegate: PlayerCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let playerVM = PlayerViewModel()
        let playerVC = PlayerViewController(viewModel: playerVM)
        playerVC.coordinator = self
        navigationController.pushViewController(playerVC, animated: false)
    }
    
    func showError(error: Error) {
        let errorVM = ErrorViewModel(notiType: .player)
        let errorVC = ErrorViewController(viewModel: errorVM, errorType: error)
        errorVC.coordinator = self
        errorVC.modalPresentationStyle = .overCurrentContext
        navigationController.present(errorVC, animated: true)
    }
    
    deinit {
        print(#function, self)
    }
}
