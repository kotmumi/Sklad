//
//  WriteOffViewController.swift
//  Sklad
//
//  Created by Кирилл Котыло on 20.08.25.
//

import UIKit
import Combine

final class ProjectViewController: UIViewController {
    
    let projectView = ProjectView()
    var coordinator: DetailsCoordinator?
    private let viewModel: DetailsViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = projectView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        bind()
    }
    
    private func setupUI() {
        projectView.projectTableView.register(ProjectViewCell.self, forCellReuseIdentifier: ProjectViewCell.reuseIdentifier)
        
        projectView.projectTableView.dataSource = self
        projectView.projectTableView.delegate  = self
        
        projectView.projectTableView.backgroundColor = .clear
        projectView.projectTableView.layer.masksToBounds = true
        
        projectView.searchTextField.delegate = self
    }
    
    private func setupConstraints() {
        
    }
    
    private func bind() {
        viewModel.projectInFilters
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.projectView.projectTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
}

extension ProjectViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        print("viewModel.projectInFilters.value.count\(viewModel.projectInFilters.value.count)")
        return viewModel.projectInFilters.value.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProjectViewCell.reuseIdentifier, for: indexPath) as? ProjectViewCell else {
            return UITableViewCell()
        }
        cell.config(project: viewModel.projectInFilters.value[indexPath.section])
        print("viewModel.projectInFilters.value[indexPath.section]\(viewModel.projectInFilters.value[indexPath.section])")
        return cell
    }
}

extension ProjectViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 4
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.project.send(viewModel.projects[indexPath.section])
        coordinator?.dismissView()
    }
   
}

extension ProjectViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        viewModel.searchText.send(textField.text ?? "")
        
    }
}
