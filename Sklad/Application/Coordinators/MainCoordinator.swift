//
//  MainCoordinator.swift
//  Sklad
//
//  Created by Кирилл Котыло on 29.07.25.
//

import UIKit

final class MainCoordinator: Coordinator {
    
    weak var parentCoordinator: (any Coordinator)?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var tabBarController: MainTabBarController?
  
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        print(navigationController.viewControllers)
    }
    
    func start() {
        let mainVC = MainViewController()
            mainVC.coordinator = self
            navigationController.setViewControllers([mainVC], animated: false)
        print(navigationController.viewControllers)
    }
  
    func goToFilter() {
        
    }
    
    func goToSearch() {
        
    }
    
    func goToDetails() {
        let detailsCoordinator = DetailsCoordinator(navigationController: navigationController)
        detailsCoordinator.parentCoordinator = self
        addChild(detailsCoordinator)
        detailsCoordinator.start()
    }
}
