//
//  AccountView.swift
//  StockTrace
//
//  Created by Кирилл Котыло on 25.06.25.
//

import UIKit
import GoogleSignIn

class AccountView: UIView {
    
    let userProfileView = UserProfileView()
    
    private let appLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sklad"
        label.textAlignment = .center
        label.textColor = .textPrimary
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let logoImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let designerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .textSecondary
        label.font = .systemFont(ofSize: 14, weight: .regular)
        
        let attributedText = NSMutableAttributedString(string: "Designer ")
        
        let italicText = NSAttributedString(
            string: "Anton Liukevich",
            attributes: [
                .font: UIFont.italicSystemFont(ofSize: 14),
            ]
        )
        attributedText.append(italicText)
        
        label.attributedText = attributedText
        return label
    }()
    
    private let developerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .textSecondary
        label.font = .systemFont(ofSize: 14, weight: .regular)
        
        let attributedText = NSMutableAttributedString(string: "Developer ")
        
        let italicText = NSAttributedString(
            string: "Kiryl Katyla",
            attributes: [
                .font: UIFont.italicSystemFont(ofSize: 14),
            ]
        )
        attributedText.append(italicText)
        
        label.attributedText = attributedText
        return label
    }()
    
    private let yearrLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "\u{00A9} 2025"
        label.textAlignment = .center
        label.textColor = .textSecondary
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
        backgroundColor = .backgroundSecondary

        addSubview(userProfileView)
        addSubview(vStack)
        hStack.addArrangedSubview(appLabel)
        hStack.addArrangedSubview(logoImage)
        hStack.addArrangedSubview(yearrLabel)
        vStack.addArrangedSubview(hStack)
        vStack.addArrangedSubview(designerLabel)
        vStack.addArrangedSubview(developerLabel)
       // vStack.addArrangedSubview(yearrLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            userProfileView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            userProfileView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            userProfileView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            vStack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            vStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            logoImage.heightAnchor.constraint(equalToConstant: 20),
            logoImage.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func config(user: GIDGoogleUser? = nil) {
        userProfileView.config(user: user)
    }
}
