//
//  PlayerCoordinator.swift
//  PetApp
//
//  Created by 정성윤 on 4/8/25.
//
import UIKit

final class PlayerCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    
    init(
        navigationController: UINavigationController,
        parentCoordinator: Coordinator? = nil
    ) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
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
    
    func finish() {
        parentCoordinator?.childDidFinish(self)
        print(#function, self)
    }
    
    deinit {
        print(#function, self)
    }
}
