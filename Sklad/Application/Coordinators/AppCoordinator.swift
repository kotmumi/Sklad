//
//  AppCoordinator.swift
//  Sklad
//
//  Created by Кирилл Котыло on 29.07.25.
//

import UIKit
import Lottie

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
        let launchViewController = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()!
        self.window.rootViewController = launchViewController
        self.window.makeKeyAndVisible()
        setupLottieAnimation(on: launchViewController)
       
    }
    
    private func setupLottieAnimation(on viewController: UIViewController) {
        let animationView = LottieAnimationView(name: "Animation")
        animationView.backgroundColor = .backgroundAnimation
        animationView.frame = viewController.view.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        viewController.view.addSubview(animationView)
        animationView.animationSpeed = 0.7
        animationView.play(fromFrame: 0, toFrame: 100, loopMode: .playOnce) { [weak self] _ in
            Task {
                let isAuth = await self?.googleSignIn.checkUserAuth()
                if isAuth ?? false {
                    self?.showMainFlow()
                } else {
                    self?.showAuthFlow()
                }
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
        DispatchQueue.main.async { [weak self] in
            
            guard let self else { return }
            
            let tabBarController = MainTabBarController()
            
            let mainTab = self.createMainTab()
            //let favoriteTab = self.createFavoriteTab()
          //  let scannerTab = self.createScannerTab()
            let accountTab = self.createAccountTab()

            guard let mainNavigationController = mainTab.navigationController as? CustomNavigationController else { return }
            tabBarController.viewControllers = [mainNavigationController/*, scannerTab.navController*/, accountTab.navController]
            
            mainTab.parentCoordinator = self
            self.addChild(mainTab)
            
            self.window.rootViewController = tabBarController
            self.window.makeKeyAndVisible()
            mainTab.start()
        }
    }
    
    private func createMainTab() -> MainCoordinator {
        let coordinator = MainCoordinator(coreDataService: coreDataService)
        
        let viewModel = MainViewModel(
                    googleSheetsManager: googleSheetsService,
                    coreDataService: coreDataService,
                    coordinator: coordinator
                )
        
        let viewController = MainViewController(viewModel: viewModel)
        viewController.coordinator = coordinator
        
        let navController = CustomNavigationController(rootViewController: viewController)
        coordinator.navigationController = navController

        navController.tabBarItem = UITabBarItem(
            title: "Главная",
            image: UIImage(systemName: "house.circle.fill"),
            tag: 0
        )
        
        return coordinator
    }
    
    private func createFavoriteTab() -> (navController: UINavigationController, coordinator: Coordinator) {
        let coordinator = MainCoordinator(coreDataService: coreDataService)
        
        let viewModel = MainViewModel(
                    googleSheetsManager: googleSheetsService,
                    coreDataService: coreDataService,
                    coordinator: coordinator
                )
        
        let viewController = MainViewController(viewModel: viewModel)
        viewController.coordinator = coordinator
        
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem = UITabBarItem(
            title: "Избранное",
            image: UIImage(systemName: "bookmark.circle.fill"),
            tag: 1
        )
        
        return (navController, self)
    }

    private func createScannerTab() -> (navController: UINavigationController, coordinator: Coordinator) {
        let scanerViewModel = ScanerViewModel(coreDataService: coreDataService)
        let viewController = ScanerViewController(viewModel: scanerViewModel)
        
        let navController = CustomNavigationController(rootViewController: viewController)
        navController.tabBarController?.isTabBarHidden = true
        
        let coordinator = ScannerCoordinator(coreDataService: coreDataService, navigationController: navController)
        viewController.coordinator = coordinator
        coordinator.parentCoordinator = self
        self.addChild(coordinator)
        
        
        navController.tabBarItem = UITabBarItem(
            title: "Scaner",
            image: UIImage(systemName: "qrcode.viewfinder"),
            tag: 1
        )
        return (navController, coordinator)
    }

    private func createAccountTab() -> (navController: UINavigationController, coordinator: Coordinator) {
        let viewController = AccountViewController()
        viewController.coordinator = self
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem = UITabBarItem(
            title: "Профиль",
            image: UIImage(systemName: "person.circle.fill"),
            tag: 2
        )
        
        return (navController, self)
    }
}
