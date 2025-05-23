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
    
    weak var delegate: ErrorDelegate?
    init(
        navigationController: UINavigationController,
        parentCoordinator: Coordinator? = nil
    ) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
    }
    
    func start() {
        if let playerVM = DIContainer.shared.resolveFactory(type: PlayerViewModel.self) {
            let playerVC = PlayerViewController(viewModel: playerVM)
            playerVC.coordinator = self
            navigationController.pushViewController(playerVC, animated: false)
        }
    }
    
    func showError(error: Error) {
        let errorVM = ErrorViewModel(notiType: .player)
        let errorVC = ErrorViewController(viewModel: errorVM, errorType: error)
        errorVC.delegate = self
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

extension PlayerCoordinator: ErrorDelegate {
    
    func reloadNetwork(type: ErrorSenderType) {
        switch type {
        case .player:
            delegate?.reloadNetwork(type: .player)
        default:
            break
        }
    }
    
}
