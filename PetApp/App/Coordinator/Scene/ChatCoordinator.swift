//
//  ChatCoordinator.swift
//  PetApp
//
//  Created by 정성윤 on 4/8/25.
//
import UIKit

final class ChatCoordinator: Coordinator {
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
        if let chatVM = DIContainer.shared.resolveFactory(type: ChatViewModel.self) {
            let chatVC = ChatViewController(viewModel: chatVM)
            chatVC.coordinator = self
            navigationController.pushViewController(chatVC, animated: false)
        }
    }
    
    func showChatDetail(with entity: HomeEntity) {
        if let viewModel = DIContainer.shared.resolveFactory(type: ChatDetailViewModel.self, entity: entity) {
            let chatDetailVC = ChatDetailViewController(viewModel: viewModel)
            chatDetailVC.coordinator = self
            navigationController.pushViewController(chatDetailVC, animated: true)
        }
    }
    
    func showList() {
        if let listVM = DIContainer.shared.resolveFactory(type: ListViewModel.self) {
            let listVC = ListViewController(viewModel: listVM)
            listVC.chatCoord = self
            navigationController.pushViewController(listVC, animated: true)
        }
    }
    
    func showError(error: Error) {
        let errorVM = ErrorViewModel(notiType: .chat)
        let errorVC = ErrorViewController(viewModel: errorVM, errorType: error)
        errorVC.coordinator = self
        errorVC.delegate = self
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

extension ChatCoordinator: ErrorDelegate {
    
    func reloadNetwork(type: ErrorSenderType) {
        switch type {
        case .chat:
            delegate?.reloadNetwork(type: .chat)
        default:
            break
        }
    }
    
}
