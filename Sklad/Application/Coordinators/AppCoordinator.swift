//
//  AppCoordinator.swift
//  Sklad
//
//  Created by Кирилл Котыло on 29.07.25.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: Coordinator?
    private let window: UIWindow
    private let googleSignIn = GoogleSignInService()
    
    init (window: UIWindow) {
        self.window = window
    }
    
    func start() {
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
        DispatchQueue.main.async {
            let authNavigationController = UINavigationController()
            let authCoordinator = AuthCoordinator(navigationController: authNavigationController)
            
            authCoordinator.onAuthSuccess = { [weak self] in
                self?.showMainFlow()
                self?.removeChild(authCoordinator)
            }
            
            self.addChild(authCoordinator)
            authCoordinator.start()
            self.window.rootViewController = authNavigationController
            self.window.makeKeyAndVisible()
        }
    }
    
    private func showMainFlow() {
        DispatchQueue.main.async {
            
            let tabBarController = MainTabBarController()
            
            let mainVC = MainViewController()
            let scanerVC = ScannerViewController(items: [])
            let accountVC = AccountViewController()
            
            let mainNavigationController = CustomNavigationController(viewController: mainVC)
            let scanerNavigationController = UINavigationController(rootViewController: scanerVC)
            let accountNavigationController = UINavigationController(rootViewController: accountVC)
            
            let mainCoordinator = MainCoordinator(navigationController: mainNavigationController)
            mainCoordinator.start()
            
            mainVC.coordinator = mainCoordinator
            accountVC.coordinator = self
            
            mainNavigationController.tabBarItem = UITabBarItem(title: "Sklad", image: UIImage(systemName: "tray.full.fill"), tag: 0)
            scanerNavigationController.tabBarItem = UITabBarItem(title: "Scaner", image: UIImage(systemName: "qrcode.viewfinder"), tag: 1)
            accountNavigationController.tabBarItem = UITabBarItem(title: "Account", image: UIImage(systemName: "person.crop.circle"), tag: 2)
            
            tabBarController.viewControllers = [mainNavigationController,scanerNavigationController, accountNavigationController]
            mainCoordinator.parentCoordinator = self
            self.addChild(mainCoordinator)
            
            self.window.rootViewController = tabBarController
            self.window.makeKeyAndVisible()
        }
    }
}
