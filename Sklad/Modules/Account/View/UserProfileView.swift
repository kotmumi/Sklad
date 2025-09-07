//
//  UserProfileView.swift
//  Sklad
//
//  Created by Кирилл Котыло on 5.09.25.
//
import GoogleSignIn
import UIKit

final class UserProfileView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Профиль"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    private let vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .leading
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 0.5)
        view.layer.cornerRadius = 45
        view.layer.borderWidth = 2
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()
    
    private let avatarLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 45, weight: .bold)
        label.text = "A"
        label.textColor = .systemBlue
        label.textAlignment = .center
        return label
    }()
    
    private let titleNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Имя"
        label.textAlignment = .left
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Kirill"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Email"
        label.textAlignment = .left
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = "Email@gmail.com"
        textField.textAlignment = .left
        textField.textColor = .systemGray
        textField.isEnabled = false
        textField.font = .systemFont(ofSize: 14, weight: .regular)
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        textField.backgroundColor = .systemGray6
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        textField.rightViewMode = .always
        return textField
    }()
    
    let signOutButton: UIButton = {
       let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        button.setTitle("Выйти", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.9352422592, green: 0.7374092125, blue: 0.7222978784, alpha: 0.7824891427)
        button.layer.cornerRadius = 8
        button.tintColor = .red
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
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .background
        layer.cornerRadius = 25
        
        addSubview(titleLabel)
        addSubview(containerView)
        containerView.addSubview(avatarLabel)
        addSubview(vStack)
        vStack.addArrangedSubview(titleNameLabel)
        vStack.addArrangedSubview(nameLabel)
        addSubview(emailLabel)
        addSubview(emailTextField)
        addSubview(signOutButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            
            containerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            containerView.heightAnchor.constraint(equalToConstant: 90),
            containerView.widthAnchor.constraint(equalTo: containerView.heightAnchor),
            
            avatarLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            avatarLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            avatarLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            avatarLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            
            vStack.centerYAnchor.constraint(equalTo: avatarLabel.centerYAnchor),
            vStack.leadingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 32),
            vStack.trailingAnchor.constraint(equalTo: trailingAnchor,constant: 16),
            
            emailLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 32),
            emailLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            emailLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
            emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            signOutButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 32),
            signOutButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            signOutButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            signOutButton.heightAnchor.constraint(equalToConstant: 50),
            signOutButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
        ])
    }
    func config(user: GIDGoogleUser? = nil) {
        nameLabel.text = user?.profile?.name ?? "Anonym"
        emailTextField.text = user?.profile?.email ?? ""
        avatarLabel.text = String(user?.profile?.name.first ?? ".")
    }
}
