//
//  ScanerCoordinator.swift
//  Sklad
//
//  Created by Кирилл Котыло on 2.12.25.
//

import UIKit

final class ScannerCoordinator: Coordinator {
    
    var parentCoordinator: (any Coordinator)?
    var childCoordinators: [Coordinator] = []
    
    private let coreDataService: CoreDataServiceProtocol
    private let navigationController: UINavigationController//CustomNavigationController
    
    init(coreDataService: CoreDataServiceProtocol, navigationController: UINavigationController) {// CustomNavigationController) {
        self.coreDataService = coreDataService
        self.navigationController = navigationController
       // navigationController.isSearchBarHidden = true
        navigationController.navigationBar.isHidden = true
        navigationController.navigationItem.leftBarButtonItem?.isHidden = true
        navigationController.tabBarController?.isTabBarHidden = true
        
    }
    
    func start() {
        let viewModel = ScanerViewModel(coreDataService: coreDataService)
        
        let scanerViewController = ScanerViewController(viewModel: viewModel)
        scanerViewController.coordinator = self
        navigationController.pushViewController(scanerViewController, animated: true)
        
    }
    
    func goToDetails(item: Item, writeOff: [ItemWriteOff]) {
        
        let detailsCoordinator = DetailsCoordinator(navigationController: navigationController , item: item, writeOff: writeOff, coreDataService: coreDataService)
        detailsCoordinator.parentCoordinator = self
        addChild(detailsCoordinator)
        detailsCoordinator.start()
    }
    
    func back() {
        navigationController.popViewController(animated: true)
    }
    
    deinit {
        print("ScannerCoordinator deinit")
    }
}
