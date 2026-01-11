//
//  WriteOffAlertView.swift
//  Sklad
//
//  Created by Кирилл Котыло on 26.09.25.
//

import UIKit

final class WriteOffAlertView: UIView {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundPrimary
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 24
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.tintColor = .buttonPrimary
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textPrimary
        label.text = "Списано"
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textPrimary
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textPrimary
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let okButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Принять", for: .normal)
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.buttonPrimary.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(name: String, count: String) {
        nameLabel.text = name
        countLabel.text = count
    }
}

extension WriteOffAlertView {
    
    private func setupUI() {
        backgroundColor = UIColor.backgroundPrimary.withAlphaComponent(0.5)
        
        addSubview(containerView)
        containerView.addSubview(stackView)
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(countLabel)
        stackView.addArrangedSubview(okButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 280),
            
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            okButton.heightAnchor.constraint(equalToConstant: 50),
            okButton.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])
    }
}

extension UIButton {
    func showLoading() {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .systemBlue // Изменил на синий цвет
        activityIndicator.startAnimating()
        
        // Сохраняем оригинальный текст
        let originalTitle = self.title(for: .normal)
        self.setTitle(nil, for: .normal)
        self.isEnabled = false
        
        // Добавляем индикатор
        self.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        // Сохраняем ссылку на индикатор и оригинальный текст
        objc_setAssociatedObject(self, &AssociatedKeys.loadingIndicator, activityIndicator, .OBJC_ASSOCIATION_RETAIN)
        objc_setAssociatedObject(self, &AssociatedKeys.originalTitle, originalTitle, .OBJC_ASSOCIATION_RETAIN)
    }
    
    func hideLoading() {
        // Получаем индикатор и оригинальный текст
        if let activityIndicator = objc_getAssociatedObject(self, &AssociatedKeys.loadingIndicator) as? UIActivityIndicatorView {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
        
        if let originalTitle = objc_getAssociatedObject(self, &AssociatedKeys.originalTitle) as? String {
            self.setTitle(originalTitle, for: .normal)
        }
        
        self.isEnabled = true
    }
}

private struct AssociatedKeys {
    static var loadingIndicator = "loadingIndicator"
    static var originalTitle = "originalTitle"
}
