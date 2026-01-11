//
//  ProjectViewCell.swift
//  Sklad
//
//  Created by Кирилл Котыло on 6.09.25.
//

import UIKit

final class ProjectViewCell: UITableViewCell {
    
    static let reuseIdentifier = "ProjectViewCell"
    
    private var projectNumberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.backgroundColor = .buttonTertiary
        label.layer.cornerRadius = 16
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 16
        paragraphStyle.tailIndent = 16
        paragraphStyle.alignment = .natural
        paragraphStyle.lineBreakMode = .byWordWrapping

        let attributedString = NSAttributedString(
            string: "Сист.№ (37023)     ",
            attributes: [
                .paragraphStyle: paragraphStyle,
                .font: UIFont.systemFont(ofSize: 12),
                .foregroundColor: UIColor.textSecondary
            ]
        )

        label.attributedText = attributedString
        return label
    }()
    
    private var projectNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .textPrimary
        label.text = "Транспортная система паллетайзера №3 (Упак. Машина Somic сист № 36957) ПФ Пинск"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        //translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 25
        layer.borderWidth = 1
        layer.borderColor = UIColor.backgroundTertiary.cgColor
        layer.masksToBounds = true
        clipsToBounds = true
        addSubview(projectNumberLabel)
        addSubview(projectNameLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            projectNumberLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            projectNumberLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            projectNumberLabel.heightAnchor.constraint(equalToConstant: 32),
            projectNumberLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 32),
            
            projectNameLabel.topAnchor.constraint(equalTo: projectNumberLabel.bottomAnchor, constant: 16),
            projectNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            projectNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            projectNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
        ])
    }
    
    func config(project: Project) {
        
        projectNameLabel.text = project.name
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 16
        paragraphStyle.tailIndent = 16
        paragraphStyle.alignment = .natural
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        let attributedString = NSAttributedString(
            string: "Сист.№ \(String(project.systemNumber ?? 0))     ",
            attributes: [
                .paragraphStyle: paragraphStyle,
                .font: UIFont.systemFont(ofSize: 12),
                .foregroundColor: UIColor.systemGray
            ]
        )
        projectNumberLabel.attributedText = attributedString
    }
}
