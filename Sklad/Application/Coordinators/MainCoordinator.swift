//
//  MainCoordinator.swift
//  Sklad
//
//  Created by Кирилл Котыло on 29.07.25.
//

import UIKit

final class MainCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: (any Coordinator)?
    var navigationController: UINavigationController
    var mainViewModel: MainViewModel?
    
    var tabBarController: MainTabBarController?
  
    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }
    
    func start() {
        if navigationController.viewControllers.isEmpty {
            guard let mainViewModel else {return}
            let mainVC = MainViewController(viewModel: mainViewModel)
            mainVC.coordinator = self
            guard let customNavigationController = navigationController as? CustomNavigationController else { return }
            customNavigationController.viewControllers = [mainVC]
        }
    }
  
    func goToFilter(selectedCharRacts: Set<String>, selectedNumberRacts: Set<String>) {
        let filterCoordinator = FilterCoordinator(navigationController: navigationController)
        filterCoordinator.parentCoordinator = self
        addChild(filterCoordinator)
        filterCoordinator.start(selectedCharRacts, selectedNumberRacts)
    }
    
    func goToSearch() {
        
    }
    
    func goToDetails(item: Item, writeOff: [ItemWriteOff]) {
        let detailsCoordinator = DetailsCoordinator(navigationController: navigationController , item: item, writeOff: writeOff)
        detailsCoordinator.parentCoordinator = self
        addChild(detailsCoordinator)
        detailsCoordinator.start()
    }
}
