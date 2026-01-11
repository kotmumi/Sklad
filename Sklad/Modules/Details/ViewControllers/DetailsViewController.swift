//
//  DetailsViewController.swift
//  Sklad
//
//  Created by Кирилл Котыло on 3.08.25.
//

import UIKit
import Combine

final class DetailsViewController: UIViewController {
    
    private let viewModel: DetailsViewModel
    private weak var coordinator: DetailsCoordinator?
    private let detailsView = DetailsView()
    private var cancellabeles: Set<AnyCancellable> = []
    
    init(coordinator: DetailsCoordinator, viewModel: DetailsViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = detailsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        bindViewAction()
                
        viewModel.viewDidLoad.send()
        
        Task {
            try await viewModel.fetchProjects()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configNavigationBar()
    }
}

extension DetailsViewController {
    
    private func setupUI() {
        detailsView.tableView.dataSource = self
       // detailsView.tableView.delegate = self
        //detailsView.tableView.allowsSelection = false
        
        detailsView.tableView.register(HeaderViewCell.self, forCellReuseIdentifier: HeaderViewCell.reuseIdentifier)
        detailsView.tableView.register(InfoViewCell.self, forCellReuseIdentifier: InfoViewCell.reuseIdentifier)
        detailsView.tableView.register(WriteOffViewCell.self, forCellReuseIdentifier: WriteOffViewCell.reuseIdentifier)
        
        detailsView.writeOffButton.addAction(UIAction(handler: { [weak self]_ in
            self?.viewModel.navigateToWriteOff.send()
        }), for: .touchUpInside)
       
    }
    
    private func configNavigationBar() {
        guard let navController = navigationController as? CustomNavigationController else {
            fatalError("Navigation controller must be MainNavigationController")
        }
        navController.navigationBar.isHidden = false
        navController.isSearchBarHidden = true
        
        let rackView = RackView()
        rackView.config(rack: viewModel.item.location.full)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rackView)
    }
    
    private func bindViewModel() {
        viewModel.$viewState
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] viewState in
                self?.updateUI(with: viewState)
            }
            .store(in: &cancellabeles)
        
        viewModel.navigateToWriteOff
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.coordinator?.goToWriteOff()
            }
            .store(in: &cancellabeles)
        
        viewModel.$navigationTitle
            .receive(on: DispatchQueue.main)
            .assign(to: \.title, on: navigationItem)
            .store(in: &cancellabeles)
        
        viewModel.isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
            
                self?.detailsView.tableView.reloadData()
            }
            .store(in: &cancellabeles)
    }
    
    private func bindViewAction() {
        let segmentedControl = detailsView.segmentedControl.segmentedControl
        
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
    }
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        viewModel.segmentChanged.send(sender.selectedSegmentIndex)
    }
    
    private func restoreWriteOff (item: ItemWriteOff) async throws {
        try await viewModel.deleteWriteOff(item: item)
    }
    
    private func updateUI(with viewState: DetailsViewState) {
//        detailsView.segmentedControl.segmentedControl.selectedSegmentIndex = viewState.selectedStatus.segmentIndex
//        detailsView.segmentedControl.segmentedControl.selectedSegmentTintColor = viewState.selectedStatus.color
//        
        detailsView.writeOffButton.isHidden = viewState.isWriteOffButtonHidden
        
        detailsView.tableView.reloadData()
    }
}

extension DetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.viewState?.tableData.numberOfRows ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellType = viewModel.viewState.flatMap({ _ in viewModel.cellType(for: indexPath) }) else {
            return UITableViewCell()
        }
        
        switch cellType {
        case .header(let item):
            let cell = tableView.dequeueReusableCell(withIdentifier: HeaderViewCell.reuseIdentifier, for: indexPath) as! HeaderViewCell
            cell.config(item: item)
            return cell
            
        case .info(let item, let writeOffs):
            let cell = tableView.dequeueReusableCell(withIdentifier: InfoViewCell.reuseIdentifier, for: indexPath) as! InfoViewCell
            cell.config(item: item, writeOff: writeOffs)
            return cell
            
        case .writeOff(let item, let isTest):
            let cell = tableView.dequeueReusableCell(withIdentifier: WriteOffViewCell.reuseIdentifier, for: indexPath) as! WriteOffViewCell
            
            cell.config(item: item, isTest: isTest) { [weak self] in
                Task {
                    self?.coordinator?.showReturnItemAlert(item.name, item.quantity)
                    try await self?.restoreWriteOff(item: item)
                    self?.viewModel.removeWriteOffItem(at: item.id)
                  //  DispatchQueue.main.async() {
                    //    tableView.reloadData()
                    //}
                    
                }
            }
            return cell
        }
    }
}

extension DetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
