//
//  SceneDelegate.swift
//  PetApp
//
//  Created by 정성윤 on 3/21/25.
//
//
//  SceneDelegate.swift
//  PetApp
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    private var networkMonitor: NetworkMonitorManagerType = NetworkMonitorManager()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        sleep(1)
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        DIContainer.setupDependencies()
        
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        appCoordinator = AppCoordinator(navigationController: navigationController)
        appCoordinator?.start()
        
        window?.rootViewController = navigationController
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
                if let presentedVC = rootViewController.presentedViewController as? ErrorViewController {
                    presentedVC.dismiss(animated: true)
                }
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
