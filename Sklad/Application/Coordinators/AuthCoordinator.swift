//
//  AuthCoordinator.swift
//  Sklad
//
//  Created by Кирилл Котыло on 29.07.25.
//

import UIKit

final class AuthCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var childCoordinators: [any Coordinator] = []
   
    func start() {
        DispatchQueue.main.async {
            let authVC = AuthViewController()
            self.navigationController.setViewControllers([authVC], animated: true)
        }
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
}
