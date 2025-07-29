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
    private let googleSignIn = GoogleSignIn()
    
    init (window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }
    
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        Task {
            let isAuth = await googleSignIn.checkUserAuth()
            if isAuth {
                showMainFlow()
            } else {
                showAuthFlow()
            }
        }
       
    }
    
    private func showAuthFlow() {
        
    }
    
    private func showMainFlow() {
        
    }
}
