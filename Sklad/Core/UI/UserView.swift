//
//  UserView.swift
//  Sklad
//
//  Created by Кирилл Котыло on 24.09.25.
//

import UIKit

final class UserView: UIView {
    
    var height: CGFloat = 200
    
    private var tableViewHeightConstraint: NSLayoutConstraint!
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundSecondary
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .textPrimary
        label.text = "Кто списывает"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let separatorTop: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundTertiary
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "plus.circle")
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let userTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UserView {
    private func setupUI() {
        
        translatesAutoresizingMaskIntoConstraints = false
        layer.masksToBounds = true
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.backgroundTertiary.cgColor
        backgroundColor = .backgroundSecondary
    
        containerView.addSubview(titleLabel)
        containerView.addSubview(imageView)
        containerView.addSubview(separatorTop)
        addSubview(containerView)
        addSubview(userTableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            separatorTop.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            separatorTop.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            separatorTop.heightAnchor.constraint(equalToConstant: 1),
            separatorTop.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            separatorTop.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            //titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0),
            
            imageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalToConstant: 24),
            imageView.widthAnchor.constraint(equalToConstant: 24),
            
            userTableView.topAnchor.constraint(equalTo: containerView.bottomAnchor),
            userTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            userTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            userTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        tableViewHeightConstraint = userTableView.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeightConstraint.isActive = true
    }
    
    func updateTableViewHeight() {
        layoutIfNeeded()
        let contentHeight = userTableView.contentSize.height
        
        let finalHeight = min(contentHeight, height)
        
        tableViewHeightConstraint.constant = finalHeight
            layoutIfNeeded()
    }
    
    func tapImage(isOpen: Bool) {
        if !isOpen {
            imageView.image = UIImage(systemName: "plus.circle")
        } else {
            imageView.image = UIImage(systemName: "minus.circle")
        }
    }
}
