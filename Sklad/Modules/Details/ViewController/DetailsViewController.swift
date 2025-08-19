//
//  DetailsViewController.swift
//  Sklad
//
//  Created by Кирилл Котыло on 3.08.25.
//

import UIKit

class DetailsViewController: UIViewController {
    
    private let detailsView: DetailsView = DetailsView()
    var coordinator: DetailsCoordinator?
    
    override func loadView() {
        super.loadView()
        view = detailsView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .background
        appearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationItem.title = "Остатки"
    }
}
