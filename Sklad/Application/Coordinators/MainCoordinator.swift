//
//  MainCoordinator.swift
//  Sklad
//
//  Created by Кирилл Котыло on 29.07.25.
//

import UIKit

final class MainCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: (any Coordinator)?
    var navigationController: UINavigationController
    
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
  
    func goToFilter(selectedCharRacts: Set<String>, selectedNumberRacts: Set<String>) {
        let filterCoordinator = FilterCoordinator(navigationController: navigationController)
        filterCoordinator.parentCoordinator = self
        addChild(filterCoordinator)
        filterCoordinator.start(selectedCharRacts, selectedNumberRacts)
    }
    
    func goToSearch() {
        
    }
    
    func goToDetails(item: Item, writeOff: [ItemWriteOff]) {
        let detailsCoordinator = DetailsCoordinator(navigationController: navigationController, item: item, writeOff: writeOff)
        detailsCoordinator.parentCoordinator = self
        addChild(detailsCoordinator)
        detailsCoordinator.start()
    }
}
