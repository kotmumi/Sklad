//
//  AuthCoordinator.swift
//  Sklad
//
//  Created by Кирилл Котыло on 29.07.25.
//

import UIKit

final class AuthCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    
    
    var onAuthSuccess: (() -> Void)?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
            let authVC = AuthViewController()
            authVC.coordinator = self
            self.navigationController.setViewControllers([authVC], animated: true)
    }
    
    func handleAuthSuccess(token: String) {
            onAuthSuccess?()
            navigationController.dismiss(animated: true)
        }
        
        deinit {
            print("AuthCoordinator deallocated")
        }
}
