//
//  MainCoordinator.swift
//  Sklad
//
//  Created by Кирилл Котыло on 29.07.25.
//

import UIKit

final class MainCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    func start() {
        DispatchQueue.main.async {
            let mainVC = MainViewController()
            self.navigationController.setViewControllers([mainVC], animated: true)
        }
        
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
}
