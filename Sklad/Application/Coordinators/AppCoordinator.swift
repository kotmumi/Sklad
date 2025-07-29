//
//  AppCoordinator.swift
//  Sklad
//
//  Created by Кирилл Котыло on 29.07.25.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    private let window: UIWindow
    
    init (window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }
    
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    private func showAuthFlow() {
        
    }
    
    private func showMainFlow() {
        
    }
}
