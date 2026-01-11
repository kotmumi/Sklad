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
    private let detailViewModel: DetailsViewModel
    private let service: GoogleSheetsService = GoogleSheetsDataService()
    private let coreDataService: CoreDataServiceProtocol
    
    init(navigationController: UINavigationController, item: Item, writeOff: [ItemWriteOff], coreDataService: CoreDataServiceProtocol) {
        self.navigationController = navigationController
        self.item = item
        self.writeOff = writeOff
        self.detailViewModel = DetailsViewModel(item: item, writeOff: writeOff, googleSheetsManager: service, coreDataService: coreDataService)
        self.coreDataService = coreDataService
        //print("DetailsCoordinator init")
    }
    
    func start() {
        let detailsVC = DetailsViewController(coordinator: self, viewModel: detailViewModel)
        
        navigationController.tabBarController?.isTabBarHidden = true
        navigationController.pushViewController(detailsVC, animated: true)
    }
    
    deinit {
        //print("DetailsCoordinator deinit")
    }
    
    func goToWriteOff() {
        let writeOffVC = WriteOffViewController(viewModel: detailViewModel)
        writeOffVC.coordinator = self
        navigationController.pushViewController(writeOffVC, animated: true)
    }
    
    func goToProjectView() {
        let projectVC = ProjectViewController(viewModel: detailViewModel)
        projectVC.coordinator = self
        navigationController.present(projectVC, animated: true)
    }
    
    func showWriteOffAlert(_ name: String,_ amount: Double) {
        let alertVC = WriteOffAlertViewController(viewModel: detailViewModel)
        alertVC.writeOffView.config(name: name, count: String(amount))
        alertVC.coordinator = self
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        navigationController.present(alertVC, animated: true)
    }
    
    func showReturnItemAlert(_ name: String,_ amount: Double) {
        let alertVC = ReturnIteemAlertViewController(viewModel: detailViewModel)
        alertVC.writeOffView.config(name: name, count: String(amount))
        alertVC.coordinator = self
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        navigationController.present(alertVC, animated: true)
    }
    
    func dismissView() {
        navigationController.dismiss(animated: true)
    }
    
    func close() {
        navigationController.popViewController(animated: true)
    }
}
