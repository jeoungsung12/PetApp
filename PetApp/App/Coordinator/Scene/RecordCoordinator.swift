//
//  RecordCoordinator.swift
//  PetApp
//
//  Created by 정성윤 on 4/8/25.
//
import UIKit

final class RecordCoordinator: Coordinator {
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
        if let recordVM = DIContainer.shared.resolveFactory(type: RecordViewModel.self) {
            let recordVC = RecordViewController(isLogo: true, viewModel: recordVM)
            recordVC.recordCoordinator = self
            navigationController.pushViewController(recordVC, animated: false)
        }
    }
    
    func showWrite() {
        if let writeVM = DIContainer.shared.resolveFactory(type: WriteViewModel.self) {
            let writeVC = WriteViewController(viewModel: writeVM)
            writeVC.coordinator = self
            navigationController.pushViewController(writeVC, animated: true)
        }
    }
    
    func showAlert(title: String, message: String, actions: [AlertAction], completion: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for action in actions {
            let alertAction = UIAlertAction(title: action.rawValue, style: action == .Cancel ? .cancel : .default) { _ in
                if action != .Cancel {
                    completion?()
                }
            }
            alertController.addAction(alertAction)
        }
        
        navigationController.present(alertController, animated: true)
    }
    
    func finish() {
        parentCoordinator?.childDidFinish(self)
        print(#function, self)
    }
    
    deinit {
        print(#function, self)
    }
}

enum AlertAction: String {
    case Ok = "확인"
    case Cancel = "취소"
}
