//
//  FilterCoordinator.swift
//  Sklad
//
//  Created by Кирилл Котыло on 25.08.25.
//

import UIKit

final class FilterCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: (Coordinator)?
    var navigationController: UINavigationController

    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let filterVC = FilterViewController(selectedCharRacts: Set<String>(), selectedNumberRacts: Set<String>())
        filterVC.coordinator = self
        navigationController.tabBarController?.isTabBarHidden = true
        self.navigationController.pushViewController(filterVC, animated: true)
    }
    
    func start(_ selectedCharRacts: Set<String>, _ selectedNumberRacts: Set<String>) {
        let filterVC = FilterViewController(selectedCharRacts: selectedCharRacts, selectedNumberRacts: selectedNumberRacts)
        filterVC.coordinator = self
        if let mainVC = navigationController.viewControllers.first(where: { $0 is MainViewController }) as? MainViewController {
            filterVC.filterDelegate = mainVC
        }
        navigationController.tabBarController?.isTabBarHidden = true
        self.navigationController.pushViewController(filterVC, animated: true)
    }
    
    func stop() {
        self.navigationController.popViewController(animated: true)
    }
}
