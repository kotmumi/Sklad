//
//  StatusIndicatorView.swift
//  Sklad
//
//  Created by Кирилл Котыло on 9.09.25.
//

import UIKit

class StatusIndicatorView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .darkGray
        label.text = "Остаток"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let codeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // Статусы
    private let activeStatus = StatusItemView(title: "Активный")
    private let testStatus = StatusItemView(title: "На тесте")
    private let writtenOffStatus = StatusItemView(title: "Списанное")
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)
        addSubview(codeLabel)
        addSubview(stackView)
        
        stackView.addArrangedSubview(activeStatus)
        stackView.addArrangedSubview(testStatus)
        stackView.addArrangedSubview(writtenOffStatus)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        codeLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            codeLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            codeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with code: String,
                  isActive: Bool = false,
                  isOnTest: Bool = false,
                  isWrittenOff: Bool = false) {
        codeLabel.text = code
        activeStatus.isSelected = isActive
        testStatus.isSelected = isOnTest
        writtenOffStatus.isSelected = isWrittenOff
    }
}

class StatusItemView: UIView {
    
    private let checkBox = UIImageView()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    var isSelected: Bool = false {
        didSet {
            updateAppearance()
        }
    }
    
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(checkBox)
        addSubview(titleLabel)
        
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            checkBox.leadingAnchor.constraint(equalTo: leadingAnchor),
            checkBox.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkBox.widthAnchor.constraint(equalToConstant: 20),
            checkBox.heightAnchor.constraint(equalToConstant: 20),
            
            titleLabel.leadingAnchor.constraint(equalTo: checkBox.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        updateAppearance()
    }
    
    private func updateAppearance() {
        let imageName = isSelected ? "checkmark.square.fill" : "square"
        let imageColor: UIColor = isSelected ? .systemBlue : .gray
        let textColor: UIColor = isSelected ? .systemBlue : .darkGray
        
        checkBox.image = UIImage(systemName: imageName)
        checkBox.tintColor = imageColor
        titleLabel.textColor = textColor
    }
}
