//
//  SceneDelegate.swift
//  PetApp
//
//  Created by 정성윤 on 3/21/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let realmRepo: UserRepositoryType = RealmUserRepository.shared
    private var networkMonitor: NetworkMonitorManagerType = NetworkMonitorManager()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        sleep(1)
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        if (realmRepo.getUserInfo()) != nil {
            window?.rootViewController = TabBarController()
        } else {
            window?.rootViewController = UINavigationController(rootViewController: ProfileViewController())
        }
        window?.makeKeyAndVisible()
        
        networkMonitor.startMonitoring { [weak self] status in
            switch status {
            case .satisfied:
                self?.dismissErrorView(scene: scene)
            case .unsatisfied:
                self?.presentErrorView(scene: scene)
            default:
                break
            }
        }
    }
    
    private func presentErrorView(scene: UIScene) {
        if let windowScene = scene as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            DispatchQueue.main.async {
                let errorViewController = ErrorViewController(viewModel: ErrorViewModel(notiType: .network), errorType: NSError())
                errorViewController.modalPresentationStyle = .overCurrentContext
                rootViewController.present(errorViewController, animated: true, completion: nil)
            }
        }
    }
    
    private func dismissErrorView(scene: UIScene) {
        if let windowScene = scene as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            DispatchQueue.main.async {
                rootViewController.dismiss(animated: true)
            }
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        networkMonitor.stopMonitoring()
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
    }
    
    
}

