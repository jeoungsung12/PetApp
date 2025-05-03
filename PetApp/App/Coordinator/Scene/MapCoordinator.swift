//
//  MapCoordinator.swift
//  PetApp
//
//  Created by 정성윤 on 5/3/25.
//
import UIKit

final class MapCoordinator: Coordinator, LocationCoordinating {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
    }
    
    func showMap(mapType: MapType, from sourceCoordinator: Coordinator) {
            if let mapVM = DIContainer.shared.resolveFactory(type: MapViewModel.self) {
                let mapVC = MapViewController(viewModel: mapVM)
                
                if let homeCoord = sourceCoordinator as? HomeCoordinator {
                    mapVC.coordinator = homeCoord
                    homeCoord.navigationController.pushViewController(mapVC, animated: true)
                } else {
                    sourceCoordinator.navigationController.pushViewController(mapVC, animated: true)
                }
            }
        }
    
    func showLocation(location: LocationViewModel.LocationEntity, from sourceCoordinator: Coordinator) {
        let locationVC = LocationPopupViewController(userLocation: location)
        locationVC.modalPresentationStyle = .overCurrentContext
        locationVC.modalTransitionStyle = .crossDissolve
        
        if let homeCoord = sourceCoordinator as? HomeCoordinator {
            locationVC.delegate = homeCoord
            homeCoord.navigationController.present(locationVC, animated: true)
        } else if let chatCoord = sourceCoordinator as? ChatCoordinator {
            locationVC.delegate = chatCoord
            chatCoord.navigationController.present(locationVC, animated: true)
        }
    }
}
