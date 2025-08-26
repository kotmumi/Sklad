//
//  ProjectPickerView.swift
//  Sklad
//
//  Created by Кирилл Котыло on 20.08.25.
//

import UIKit

final class ProjectPickerView: UIView {
    
    private let projectNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .systemGray
        label.text = "Сист.№(-)"
        label.backgroundColor = .systemGray5
        label.layer.cornerRadius = 16
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        return label
    }()
    
    private let projectNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .black
        label.text = "Выберите проект:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let chevronImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .lightGray
        return imageView
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
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 25
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        addSubview(projectNumberLabel)
        addSubview(projectNameLabel)
        addSubview(chevronImage)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            projectNumberLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            projectNumberLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            projectNumberLabel.heightAnchor.constraint(equalToConstant: 32),
            
            projectNameLabel.topAnchor.constraint(equalTo: projectNumberLabel.bottomAnchor, constant: 16),
            projectNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            projectNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            projectNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            chevronImage.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            chevronImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
}
