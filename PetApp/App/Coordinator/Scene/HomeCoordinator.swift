//
//  HomeCoordinator.swift
//  PetApp
//
//  Created by 정성윤 on 4/8/25.
//

import UIKit

final class HomeCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    
    weak var detailCoordinator: DetailCoordinating?
    weak var mapCoordinator: LocationCoordinating?
    
    weak var errorDelegate: ErrorDelegate?
    weak var locationDelegate: LocationDelegate?
    
    init(
        navigationController: UINavigationController,
        parentCoordinator: Coordinator? = nil
    ) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
    }
    
    func start() {
        if let homeVM = DIContainer.shared.resolveFactory(type: HomeViewModel.self) {
            let homeVC = HomeViewController(viewModel: homeVM)
            homeVC.coordinator = self
            navigationController.pushViewController(homeVC, animated: false)
        }
    }
    
    func showDetail(with entity: HomeEntity) {
        detailCoordinator?.showDetail(with: entity, from: self)
    }
    
    func showList() {
        if let listVM = DIContainer.shared.resolveFactory(type: ListViewModel.self) {
            let listVC = ListViewController(viewModel: listVM)
            listVC.homeCoord = self
            navigationController.pushViewController(listVC, animated: true)
        }
    }
    
    func showPhoto() {
        if let photoVM = DIContainer.shared.resolveFactory(type: PhotoViewModel.self) {
            let photoVC = PhotoViewController(viewModel: photoVM)
            photoVC.coordinator = self
            navigationController.pushViewController(photoVC, animated: true)
        }
    }
    
    func showMap(mapType: MapType) {
        mapCoordinator?.showMap(mapType: mapType, from: self)
    }
    
    func showLike() {
        if let likeVM = DIContainer.shared.resolveFactory(type: LikeViewModel.self) {
            let likeVC = LikeViewController(viewModel: likeVM)
            likeVC.homeCoord = self
            navigationController.pushViewController(likeVC, animated: true)
        }
    }
    
    func showSponsor() {
        if let sponsorVM = DIContainer.shared.resolveFactory(type: SponsorViewModel.self) {
            let sponsorVC = SponsorViewController(viewModel: sponsorVM)
            sponsorVC.coordinator = self
            navigationController.pushViewController(sponsorVC, animated: true)
        }
    }
    
    func showError(error: Error) {
        let errorVM = ErrorViewModel(notiType: .home)
        let errorVC = ErrorViewController(viewModel: errorVM, errorType: error)
        errorVC.delegate = self
        errorVC.coordinator = self
        errorVC.modalPresentationStyle = .overCurrentContext
        navigationController.present(errorVC, animated: true)
    }
    
    func showLocation(location: LocationViewModel.LocationEntity) {
        mapCoordinator?.showLocation(location: location, from: self)
    }
    
    func finish() {
        parentCoordinator?.childDidFinish(self)
        print(#function, self)
    }
    
    deinit {
        print(#function, self)
    }
}

extension HomeCoordinator: ErrorDelegate, LocationDelegate {
    
    func reloadLoaction(_ locationEntity: LocationViewModel.LocationEntity) {
        locationDelegate?.reloadLoaction(locationEntity)
    }
    
    func reloadNetwork(type: ErrorSenderType) {
        switch type {
        case .home:
            errorDelegate?.reloadNetwork(type: .home)
        default:
            break
        }
    }
}
