//
//  projectView.swift
//  Sklad
//
//  Created by Кирилл Котыло on 20.08.25.
//

import UIKit

final class ProjectView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .black
        label.text = "Проекты:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let separatorTop: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let projectTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .background
        addSubview(titleLabel)
        addSubview(separatorTop)
        addSubview(projectTableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 32),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            separatorTop.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            separatorTop.centerXAnchor.constraint(equalTo: centerXAnchor),
            separatorTop.heightAnchor.constraint(equalToConstant: 1),
            separatorTop.widthAnchor.constraint(equalTo: widthAnchor),
            
            projectTableView.topAnchor.constraint(equalTo: separatorTop.bottomAnchor,constant: 16),
            projectTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            projectTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant:  -16),
            projectTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
