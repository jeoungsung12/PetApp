//
//  MyPageCoordinator.swift
//  PetApp
//
//  Created by 정성윤 on 4/8/25.
//
import UIKit

protocol MyPageCoordinatorDelegate: AnyObject {
    func myPageCoordinatorDidFinish(_ coordinator: MyPageCoordinator)
}

final class MyPageCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var delegate: MyPageCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let myPageVM = MyPageViewModel()
        let myPageVC = MyPageViewController(viewModel: myPageVM)
        myPageVC.coordinator = self
        navigationController.pushViewController(myPageVC, animated: false)
    }
    
    func showDetail(with entity: HomeEntity) {
        let detailVM = DetailViewModel(model: entity)
        let detailVC = DetailViewController(viewModel: detailVM)
        detailVC.mypageCoord = self
        navigationController.pushViewController(detailVC, animated: true)
    }
    
    func showLike() {
        let likeVM = LikeViewModel()
        let likeVC = LikeViewController(viewModel: likeVM)
        likeVC.mypageCoord = self
        navigationController.pushViewController(likeVC, animated: true)
    }
    
    func showRecord() {
        let recordVM = RecordViewModel()
        let recordVC = RecordViewController(viewModel: recordVM)
        recordVC.mypageCoordinator = self
        navigationController.pushViewController(recordVC, animated: true)
    }
    
    func showProfileEdit() {
        let sheetProfileVM = ProfileViewModel()
        let sheetProfileVC = SheetProfileViewController(viewModel: sheetProfileVM)
        sheetProfileVC.coordinator = self
        
        navigationController.pushViewController(sheetProfileVC, animated: true)
    }
    
    func showProfileImageSelection(currentImage: String?, delegate: ProfileImageDelegate) {
        let profileImageVM = ProfileImageViewModel()
        let profileImageVC = ProfileImageViewController(viewModel: profileImageVM)
        profileImageVC.mypageCoord = self
        profileImageVC.profileImage = currentImage
        profileImageVC.profileDelegate = delegate
        navigationController.pushViewController(profileImageVC, animated: true)
    }
    
    func showFAQ() {
        let faqVM = FAQViewModel()
        let faqVC = FAQViewController(viewModel: faqVM)
        faqVC.coordinator = self
        navigationController.pushViewController(faqVC, animated: true)
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
    }
    
    func popSheetProfile() {
        let sheetProfileVM = ProfileViewModel()
        let sheetProfileVC = SheetProfileViewController(viewModel: sheetProfileVM)
        sheetProfileVC.coordinator = self
        
        navigationController.popViewController(animated: true)
    }
    
    deinit {
        print(#function, self)
    }
}
