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
        label.textColor = .textPrimary
        label.text = "Выбрать проект"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let separatorTop: UIView = {
        let view = UIView()
        view.backgroundColor = .textSecondary
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let projectTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    let searchTextField: UISearchTextField = {
        let textField = UISearchTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 22
        return textField
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
        backgroundColor = .backgroundSecondary
        layer.cornerRadius = 25
        addSubview(searchTextField)
        addSubview(titleLabel)
        addSubview(separatorTop)
        addSubview(projectTableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            searchTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            searchTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            searchTextField.heightAnchor.constraint(equalToConstant: 44),
            
            separatorTop.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 16),
            separatorTop.centerXAnchor.constraint(equalTo: centerXAnchor),
            separatorTop.heightAnchor.constraint(equalToConstant: 1),
            separatorTop.widthAnchor.constraint(equalTo: widthAnchor),
            
            projectTableView.topAnchor.constraint(equalTo: separatorTop.bottomAnchor,constant: 8),
            projectTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            projectTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant:  -16),
            projectTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
