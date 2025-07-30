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
    
    func start() {
        DispatchQueue.main.async {
            self.setupTabBar()
            self.navigationController.setViewControllers([self.tabBarController], animated: true)
        }
        
    }
    func setupTabBar() {
        let navigationController1 = UINavigationController(rootViewController: MainViewController())
        let navigationController2 = UINavigationController(rootViewController: MainViewController())
        let navigationController3 = UINavigationController(rootViewController: MainViewController())
        let navigationController4 = UINavigationController(rootViewController: MainViewController())
        
        navigationController1.tabBarItem = UITabBarItem(title: "Sklad", image: UIImage(systemName: "tray.full.fill"), tag: 0)
        navigationController2.tabBarItem = UITabBarItem(title: "List", image: UIImage(systemName: "list.bullet.circle.fill"), tag: 1)
        navigationController3.tabBarItem = UITabBarItem(title: "Scaner", image: UIImage(systemName: "barcode"), tag: 2)
        navigationController4.tabBarItem = UITabBarItem(title: "Account", image: UIImage(systemName: "person.crop.circle"), tag: 3)
        
        tabBarController.viewControllers = [navigationController1, navigationController2, navigationController3, navigationController4]
        
    }
}
