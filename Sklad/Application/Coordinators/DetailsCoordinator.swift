//
//  DetailsCoordinator.swift
//  Sklad
//
//  Created by Кирилл Котыло on 3.08.25.
//

import UIKit

class DetailsCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    
    private let item: Item
    private var writeOff: [ItemWriteOff]
    
    init(navigationController: UINavigationController, item: Item, writeOff: [ItemWriteOff]) {
        self.navigationController = navigationController
        self.item = item
        self.writeOff = writeOff
        print("DetailsCoordinator init")
    }
    
    func start() {
        let detailsVC = DetailsViewController(item: item, writeOff: writeOff)
        detailsVC.coordinator = self
        navigationController.tabBarController?.isTabBarHidden = true
        self.navigationController.pushViewController(detailsVC, animated: true)
    }
    
    deinit {
        print("DetailsCoordinator deinit")
    }
    
    func goToWriteOff() {
        let writeOffVC = WriteOffViewController()
        navigationController.present(writeOffVC, animated: true)
    }
}
