//
//  ProfileCoordinator.swift
//  PetApp
//
//  Created by 정성윤 on 4/8/25.
//
import UIKit

protocol ProfileCoordinatorDelegate: AnyObject {
    func didFinishProfile()
}

final class ProfileCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var delegate: ProfileCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let profileVM = ProfileViewModel()
        let profileVC = ProfileViewController(viewModel: profileVM)
        profileVC.coordinator = self
        navigationController.pushViewController(profileVC, animated: false)
    }
    
    func showProfileImageSelection(currentImage: String?, delegate: ProfileImageDelegate) {
        let profileVM = ProfileImageViewModel()
        let profileImageVC = ProfileImageViewController(viewModel: profileVM)
        profileImageVC.profileCoord = self
        profileImageVC.profileImage = currentImage
        profileImageVC.profileDelegate = delegate
        navigationController.pushViewController(profileImageVC, animated: true)
    }
    
    func navigateToTabBar() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
              let appCoordinator = sceneDelegate.appCoordinator else { return }
        
        appCoordinator.childCoordinators.removeAll()
        appCoordinator.showMainTabBar()
    }
    
    
    deinit {
        print(#function, self)
    }
}
