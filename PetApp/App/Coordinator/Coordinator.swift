//
//  Coordinator.swift
//  PetApp
//
//  Created by 정성윤 on 4/7/25.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    var parentCoordinator: Coordinator? { get set }
    
    func start()
    func childDidFinish(_ child: Coordinator?)
    func finish()
}

extension Coordinator {
    func childDidFinish(_ child: Coordinator?) {
        if let child = child, let index = childCoordinators.firstIndex(where: { $0 === child }) {
            childCoordinators.remove(at: index)
        }
    }
    
    func finish() {
        parentCoordinator?.childDidFinish(self)
    }
}
