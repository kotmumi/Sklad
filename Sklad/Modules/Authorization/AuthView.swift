//
//  AuthorizationView.swift
//  StockTrace
//
//  Created by Кирилл Котыло on 23.06.25.
//

import UIKit
import GoogleSignIn

class AuthView: UIView {
    
    let signInButton = GIDSignInButton()
    
    private let loginTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
     let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("Войти", comment: ""), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 32
        stackView.translatesAutoresizingMaskIntoConstraints = false
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
    
    private func setupUI() {
        backgroundColor = .white
        addSubview(stackView)
        stackView.addArrangedSubview(signInButton)
    }
}

extension AuthView {
    private func setupConstraints() {
        NSLayoutConstraint.activate([

            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                               constant: 48),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                constant: -48),
            
        ])
    }
}
