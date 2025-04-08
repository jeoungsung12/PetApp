//
//  ProfileCoordinator.swift
//  PetApp
//
//  Created by 정성윤 on 4/8/25.
//
import UIKit

final class ProfileCoordinator: Coordinator {
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
        finish()
    }
    
    func finish() {
        parentCoordinator?.childDidFinish(self)
        print(#function, self)
    }
    
    deinit {
        print(#function, self)
    }
}
