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
    private let googleSheetsService = GoogleSheetsDataService()
    private let coreDataService = CoreDataService()
    
    
    init (window: UIWindow) {
        self.window = window
        _ = CoreDataManager.shared
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
            
//            let mainCoordinator = MainCoordinator(navigationController: mainNavigationController)
//            mainCoordinator.start()
            
            let tabBarController = MainTabBarController()
            
            let mainTab = self.createMainTab()
            let scannerTab = self.createScannerTab()
            let accountTab = self.createAccountTab()
            
//            let mainViewModel = MainViewModel(
//                googleSheetManager: googleSheetsService,
//                        coreDataService: coreDataService,
//                        coordinator: mainCoordinator
//                    )
//            
//            let mainVC = MainViewController(viewModel: mainViewModel)
//            let scanerVC = ScannerViewController(items: [])
//            let accountVC = AccountViewController()
//            
//            let mainNavigationController = CustomNavigationController(viewController: mainVC)
//            let scanerNavigationController = UINavigationController(rootViewController: scanerVC)
//            let accountNavigationController = UINavigationController(rootViewController: accountVC)
//            
//            
//            
//            mainVC.coordinator = mainCoordinator
//            accountVC.coordinator = self
//            
//            mainNavigationController.tabBarItem = UITabBarItem(title: "Sklad", image: UIImage(systemName: "tray.full.fill"), tag: 0)
//            scanerNavigationController.tabBarItem = UITabBarItem(title: "Scaner", image: UIImage(systemName: "qrcode.viewfinder"), tag: 1)
//            accountNavigationController.tabBarItem = UITabBarItem(title: "Account", image: UIImage(systemName: "person.crop.circle"), tag: 2)
//            
//            tabBarController.viewControllers = [mainNavigationController,scanerNavigationController, accountNavigationController]
//            mainCoordinator.parentCoordinator = self
//            self.addChild(mainCoordinator)
            tabBarController.viewControllers = [mainTab.navigationController, scannerTab.navController, accountTab.navController]
            
            mainTab.parentCoordinator = self
                  self.addChild(mainTab)
            
            self.window.rootViewController = tabBarController
            self.window.makeKeyAndVisible()
            mainTab.start()
        }
    }
    
    private func createMainTab() -> MainCoordinator {
        
        let coordinator = MainCoordinator(navigationController: CustomNavigationController(rootViewController: UIViewController()))
        let viewModel = MainViewModel(
            googleSheetsManager: googleSheetsService,
            coreDataService: coreDataService,
            coordinator: coordinator
        )
        coordinator.mainViewModel = viewModel
        let viewController = MainViewController(viewModel: viewModel)
        viewController.coordinator = coordinator
        
       // let navController = CustomNavigationController()//(viewController: viewController)
        //coordinator.navigationController = navController
        coordinator.navigationController.tabBarItem = UITabBarItem(
            title: "Sklad",
            image: UIImage(systemName: "tray.full.fill"),
            tag: 0
        )
        
        return coordinator
    }

    private func createScannerTab() -> (navController: UINavigationController, coordinator: Coordinator) {
        let viewController = ScannerViewController(items: [])
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem = UITabBarItem(
            title: "Scaner",
            image: UIImage(systemName: "qrcode.viewfinder"),
            tag: 1
        )
        
        let coordinator = AuthCoordinator(navigationController: navController)//заглушка,написать ScanerCoordinator
        return (navController, coordinator)
    }

    private func createAccountTab() -> (navController: UINavigationController, coordinator: Coordinator) {
        let viewController = AccountViewController()
        viewController.coordinator = self
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem = UITabBarItem(
            title: "Account",
            image: UIImage(systemName: "person.crop.circle"),
            tag: 2
        )
        
        return (navController, self)
    }
}
