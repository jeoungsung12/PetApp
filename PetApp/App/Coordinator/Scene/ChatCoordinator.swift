//
//  ChatCoordinator.swift
//  PetApp
//
//  Created by 정성윤 on 4/8/25.
//
import UIKit


protocol ChatCoordinatorDelegate: AnyObject {
    func chatCoordinatorDidFinish(_ coordinator: ChatCoordinator)
}

final class ChatCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var delegate: ChatCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let chatVM = ChatViewModel()
        let chatVC = ChatViewController(viewModel: chatVM)
        chatVC.coordinator = self
        navigationController.pushViewController(chatVC, animated: false)
    }
    
    func showChatDetail(with entity: HomeEntity) {
        let viewModel = ChatDetailViewModel(entity: entity)
        let chatDetailVC = ChatDetailViewController(viewModel: viewModel)
        chatDetailVC.coordinator = self
        navigationController.pushViewController(chatDetailVC, animated: true)
    }
    
    func showList() {
        let listVM = ListViewModel()
        let listVC = ListViewController(viewModel: listVM)
        listVC.chatCoord = self
        navigationController.pushViewController(listVC, animated: true)
    }
    
    func showError(error: Error) {
        let errorVM = ErrorViewModel(notiType: .chat)
        let errorVC = ErrorViewController(viewModel: errorVM, errorType: error)
        errorVC.coordinator = self
        errorVC.modalPresentationStyle = .overCurrentContext
        navigationController.present(errorVC, animated: true)
    }
    
    deinit {
        print(#function, self)
    }
}
