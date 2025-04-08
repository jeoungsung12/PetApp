//
//  SheetProfileCoordinator.swift
//  PetApp
//
//  Created by 정성윤 on 4/8/25.
//
import UIKit

protocol SheetProfileCoordinatorDelegate: AnyObject {
    func didFinishProfile()
}

final class SheetProfileCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var delegate: ProfileCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let profileVM = ProfileViewModel()
        let profileVC = SheetProfileViewController(viewModel: profileVM)
//        profileVC.sheetProfileCoord = self
        navigationController.pushViewController(profileVC, animated: false)
    }
    
    func showProfileImageSelection(currentImage: String?, delegate: ProfileImageDelegate) {
        let profileImageVM = ProfileImageViewModel()
        let profileImageVC = ProfileImageViewController(viewModel: profileImageVM)
        profileImageVC.sheetProfileCoord = self
        profileImageVC.profileImage = currentImage
        profileImageVC.profileDelegate = delegate
        navigationController.pushViewController(profileImageVC, animated: true)
    }
    
    func finishProfile() {
        delegate?.didFinishProfile()
    }
    
    deinit {
        print(#function, self)
    }
}
