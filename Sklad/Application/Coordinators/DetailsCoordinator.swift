//
//  DetailsCoordinator.swift
//  Sklad
//
//  Created by Кирилл Котыло on 3.08.25.
//

import UIKit

class DetailsCoordinator: Coordinator {
    
    weak var parentCoordinator: (Coordinator)?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        print("DetailsCoordinator init")
    }
    
    func start() {
            let detailsVC = DetailsViewController()
            detailsVC.coordinator = self
            self.navigationController.pushViewController(detailsVC, animated: true)
    }
    
    deinit {
        print("DetailsCoordinator deinit")
    }
}
