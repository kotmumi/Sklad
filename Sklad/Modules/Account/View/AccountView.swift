//
//  AccountView.swift
//  StockTrace
//
//  Created by Кирилл Котыло on 25.06.25.
//

import UIKit
import GoogleSignIn

class AccountView: UIView {
    
    private let image: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "person.crop.circle"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.tintColor = .systemGray
        return image
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Account"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        return label
    }()
    let signOutButton: UIButton = {
       let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        button.setTitle("Выйти", for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 25
        button.tintColor = .black
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
    
    private func setupUI() {
        backgroundColor = .white
      
        addSubview(userNameLabel)
        addSubview(image)
        addSubview(signOutButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            userNameLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            userNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            userNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            userNameLabel.heightAnchor.constraint(equalToConstant: 44),
            
            image.bottomAnchor.constraint(equalTo: userNameLabel.topAnchor, constant: -16),
            image.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            image.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.15),
            image.widthAnchor.constraint(equalTo: image.heightAnchor),
            
            signOutButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -80),
            signOutButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -48),
            signOutButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 48),
            signOutButton.heightAnchor.constraint(equalToConstant: 50),
            
        ])
    }
    
    func config(user: GIDGoogleUser? = nil) {
        userNameLabel.text = user?.profile?.name ?? "Anonym"
    }
}
