//
//  MyPageCoordinator.swift
//  PetApp
//
//  Created by 정성윤 on 4/8/25.
//
import UIKit

final class MyPageCoordinator: Coordinator {
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
        if let myPageVM = DIContainer.shared.resolveFactory(type: MyPageViewModel.self) {
            let myPageVC = MyPageViewController(viewModel: myPageVM)
            myPageVC.coordinator = self
            navigationController.pushViewController(myPageVC, animated: false)
        }
    }
    
    func showDetail(with entity: HomeEntity) {
        if let detailVM = DIContainer.shared.resolveFactory(type: DetailViewModel.self, entity: entity) {
            let detailVC = DetailViewController(viewModel: detailVM)
            detailVC.mypageCoord = self
            navigationController.pushViewController(detailVC, animated: true)
        }
    }
    
    func showLike() {
        if let likeVM = DIContainer.shared.resolveFactory(type: LikeViewModel.self) {
            let likeVC = LikeViewController(viewModel: likeVM)
            likeVC.mypageCoord = self
            navigationController.pushViewController(likeVC, animated: true)
        }
    }
    
    func showRecord() {
        if let recordVM = DIContainer.shared.resolveFactory(type: RecordViewModel.self) {
            let recordVC = RecordViewController(viewModel: recordVM)
            recordVC.mypageCoordinator = self
            navigationController.pushViewController(recordVC, animated: true)
        }
    }
    
    func showProfileEdit() {
        if let sheetProfileVM = DIContainer.shared.resolveFactory(type: ProfileViewModel.self) {
            let sheetProfileVC = SheetProfileViewController(viewModel: sheetProfileVM)
            sheetProfileVC.coordinator = self
            navigationController.pushViewController(sheetProfileVC, animated: true)
        }
    }
    
    func showProfileImageSelection(currentImage: String?, delegate: ProfileImageDelegate) {
        if let profileImageVM = DIContainer.shared.resolveFactory(type: ProfileImageViewModel.self) {
            let profileImageVC = ProfileImageViewController(viewModel: profileImageVM)
            profileImageVC.mypageCoord = self
            profileImageVC.profileImage = currentImage
            profileImageVC.profileDelegate = delegate
            navigationController.pushViewController(profileImageVC, animated: true)
        }
    }
    
    func showFAQ() {
        if let faqVM = DIContainer.shared.resolveFactory(type: FAQViewModel.self) {
            let faqVC = FAQViewController(viewModel: faqVM)
            faqVC.coordinator = self
            navigationController.pushViewController(faqVC, animated: true)
        }
    }
    
    func openFeedbackURL(urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    func showAlert(title: String, message: String, actions: [AlertAction], completion: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for action in actions {
            let alertAction = UIAlertAction(title: action.rawValue, style: action == .Cancel ? .destructive : .default) { _ in
                if action != .Cancel {
                    completion?()
                }
            }
            alertController.addAction(alertAction)
        }
        
        navigationController.present(alertController, animated: true)
    }
    
    func navigateToLogin() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
              let appCoordinator = sceneDelegate.appCoordinator else { return }
        
        appCoordinator.childCoordinators.removeAll()
        appCoordinator.showLogin()
        finish()
    }
    
    func popSheetProfile() {
        navigationController.popViewController(animated: true)
    }
    
    func finish() {
        parentCoordinator?.childDidFinish(self)
        print(#function, self)
    }
    
    deinit {
        print(#function, self)
    }
}
