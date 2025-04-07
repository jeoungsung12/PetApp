//
//  UIViewController + Extension.swift
//  PetApp
//
//  Created by 정성윤 on 3/22/25.
//

import UIKit
import RxSwift
import RxCocoa

extension UIViewController {
    
    enum AlertType: String, CaseIterable {
        case Ok = "확인"
        case Cancel = "취소"
    }
    
    @objc
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func setRootView(_ rootVC: UIViewController) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first else { return }
        window.rootViewController = rootVC
    }
    
    func showSettingsAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        })
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(alert, animated: true)
    }
    
    func customAlert(_ title: String = "",_ message: String = "",_ action: [AlertType] = [.Ok],_ method: @escaping () -> Void) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for type in action {
            switch type {
            case .Ok:
                let action = UIAlertAction(title: type.rawValue, style: .default) { _ in
                    method()
                }
                alertVC.addAction(action)
            case .Cancel:
                let action = UIAlertAction(title: type.rawValue, style: .destructive )
                alertVC.addAction(action)
            }
        }
        
        self.present(alertVC, animated: true)
    }
    
    func setNavigation(
        logo: Bool = false,
        title: String? = nil,
        backTitle: String? = nil,
        backImage: UIImage? = .arrowLeft,
        color: UIColor = .white
    ) {
        guard let navigationBar = navigationController?.navigationBar else { return }
        
        if logo {
            let logoImageView = UIImageView()
            logoImageView.image = UIImage(named: "NavigationLogo")
            logoImageView.contentMode = .scaleAspectFit
            let titleItem = UIBarButtonItem(customView: logoImageView)
            self.navigationItem.leftBarButtonItem = titleItem
        }
        
        let back = UIBarButtonItem(title: backTitle, style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = back
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = color
        appearance.shadowColor = nil
        
        navigationBar.tintColor = .point
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
    
    func setTabBar(color: UIColor = .white) {
        let tabBarAppearance = UITabBarAppearance()
        
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = color
        
        tabBarController?.tabBar.standardAppearance = tabBarAppearance
    }
}
