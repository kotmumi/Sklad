//
//  EditCountView.swift
//  Sklad
//
//  Created by Кирилл Котыло on 9.10.25.
//

import UIKit

final class EditCountView: UIView {
    
    let countTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = "0"
        return textField
    }()
    
    private let unitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "шт" 
        return label
    }()
    
    private let pancilImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "pencil"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EditCountView {
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
       // layer.borderColor = UIColor.background.cgColor
       // layer.borderWidth = 1
        addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(countTextField)
        horizontalStackView.addArrangedSubview(unitLabel)
        horizontalStackView.addArrangedSubview(pancilImageView)

    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            horizontalStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            horizontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
        ])
    }
}
