//
//  WriteOffViewController.swift
//  Sklad
//
//  Created by Кирилл Котыло on 20.08.25.
//

import UIKit

final class ProjectViewController: UIViewController {
    
    let projectView = ProjectView()
    var coordinator: DetailsCoordinator?
    
    override func loadView() {
        super.loadView()
        view = projectView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        projectView.projectTableView.register(ProjectViewCell.self, forCellReuseIdentifier: ProjectViewCell.reuseIdentifier)
        projectView.projectTableView.dataSource = self
        projectView.projectTableView.backgroundColor = .clear
        projectView.projectTableView.layer.masksToBounds = true
    }
    
    private func setupConstraints() {
        
    }
}

extension ProjectViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProjectViewCell.reuseIdentifier, for: indexPath) as? ProjectViewCell else {
            return UITableViewCell()
        }
        return cell
    }
}
