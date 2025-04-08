//
//  HomeCoordinator.swift
//  PetApp
//
//  Created by 정성윤 on 4/8/25.
//
import UIKit

protocol HomeCoordinatorDelegate: AnyObject {
    func homeCoordinatorDidFinish(_ coordinator: HomeCoordinator)
}

final class HomeCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var delegate: HomeCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let homeVM = HomeViewModel()
        let homeVC = HomeViewController(viewModel: homeVM)
        homeVC.coordinator = self
        navigationController.pushViewController(homeVC, animated: false)
    }
    
    func showDetail(with entity: HomeEntity) {
        let detailVM = DetailViewModel(model: entity)
        let detailVC = DetailViewController(viewModel: detailVM)
        detailVC.homeCoord = self
        navigationController.pushViewController(detailVC, animated: true)
    }
    
    func showList() {
        let listVM = ListViewModel()
        let listVC = ListViewController(viewModel: listVM)
        listVC.homeCoord = self
        navigationController.pushViewController(listVC, animated: true)
    }
    
    func showPhoto() {
        let photoVM = PhotoViewModel()
        let photoVC = PhotoViewController(viewModel: photoVM)
        photoVC.coordinator = self
        navigationController.pushViewController(photoVC, animated: true)
    }
    
    func showMap(mapType: MapType) {
        let mapVM = MapViewModel(mapType: mapType)
        let mapVC = MapViewController(viewModel: mapVM)
        mapVC.coordinator = self
        navigationController.pushViewController(mapVC, animated: true)
    }
    
    func showLike() {
        let likeVM = LikeViewModel()
        let likeVC = LikeViewController(viewModel: likeVM)
        likeVC.homeCoord = self
        navigationController.pushViewController(likeVC, animated: true)
    }
    
    func showSponsor() {
        let sponsorVM = SponsorViewModel()
        let sponsorVC = SponsorViewController(viewModel: sponsorVM)
        sponsorVC.coordinator = self
        navigationController.pushViewController(sponsorVC, animated: true)
    }
    
    deinit {
        print(#function, self)
    }
}
