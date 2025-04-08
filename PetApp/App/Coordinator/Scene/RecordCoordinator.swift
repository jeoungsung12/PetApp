//
//  RecordCoordinator.swift
//  PetApp
//
//  Created by 정성윤 on 4/8/25.
//
import UIKit

protocol RecordCoordinatorDelegate: AnyObject {
    func recordCoordinatorDidFinish(_ coordinator: RecordCoordinator)
}

final class RecordCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var delegate: RecordCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let recordVM = RecordViewModel()
        let recordVC = RecordViewController(viewModel: recordVM)
        recordVC.recordCoordinator = self
        navigationController.pushViewController(recordVC, animated: false)
    }
    
    func showWrite() {
        let writeVM = WriteViewModel()
        let writeVC = WriteViewController(viewModel: writeVM)
        writeVC.coordinator = self
        navigationController.pushViewController(writeVC, animated: true)
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
    
    deinit {
        print(#function, self)
    }
}

enum AlertAction: String {
    case Ok = "확인"
    case Cancel = "취소"
}
