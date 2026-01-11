//
//  UserViewCell.swift
//  Sklad
//
//  Created by Кирилл Котыло on 24.09.25.
//
import UIKit

final class UserViewCell: UITableViewCell {
    
    static let reuseIdentifier = "UserViewCell"
    
    var checkBox = Checkbox()
    
    private let userLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отмена", for: .normal)
        button.setTitleColor(.buttonPrimary, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        backgroundColor = .backgroundSecondary
        addSubview(checkBox)
        addSubview(userLabel)
        addSubview(cancelButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            checkBox.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            checkBox.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            checkBox.heightAnchor.constraint(equalToConstant: 24),
            checkBox.widthAnchor.constraint(equalToConstant: 24),
            checkBox.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -16),
            
            userLabel.leadingAnchor.constraint(equalTo: checkBox.trailingAnchor, constant: 8),
            userLabel.centerYAnchor.constraint(equalTo: checkBox.centerYAnchor),
            
            cancelButton.leadingAnchor.constraint(equalTo: userLabel.trailingAnchor, constant: 8),
            cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            cancelButton.centerYAnchor.constraint(equalTo: checkBox.centerYAnchor),
            
        ])
    }
    
    func config(user: User, isSelected: Bool = false) {
        userLabel.text = user.name
        checkBox.isChecked = isSelected
        
        if !checkBox.isChecked {
            cancelButton.isHidden = true
        } else {
            cancelButton.isHidden = false
        }
    }
}
