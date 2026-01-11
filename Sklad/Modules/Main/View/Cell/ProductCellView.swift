//
//  ProductCellView.swift
//  StockTrace
//
//  Created by Кирилл Котыло on 24.06.25.
//

import UIKit

class ProductCellView: UICollectionViewCell {
    
    static let identifier: String = "ProductCellView"
    
    private let nameProductLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .textPrimary
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "name product"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .backgroundTertiary
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    
    private let rackNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .textSecondary
        label.backgroundColor = .backgroundTertiary
        label.textAlignment = .center
        label.text = "rack number"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bookMarkButton: UIButton = {
        let button = UIButton(type: .custom)
        
        let symbolConfig = UIImage.SymbolConfiguration(
                pointSize: 24,
                weight: .light,
                scale: .default
            )
        button.setPreferredSymbolConfiguration(symbolConfig, forImageIn: .normal)
        
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.tintColor = .backgroundTertiary
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
    
    private func setupUI() {
        backgroundColor = .backgroundSecondary
        layer.borderColor = UIColor.backgroundTertiary.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 25
        addSubview(nameProductLabel)
        addSubview(containerView)
        containerView.addSubview(rackNumberLabel)
        addSubview(bookMarkButton)
    }
    
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            containerView.heightAnchor.constraint(equalToConstant: 24),
            containerView.widthAnchor.constraint(greaterThanOrEqualToConstant:24),
            
            rackNumberLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            rackNumberLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -6),
            rackNumberLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 6),
            
            nameProductLabel.topAnchor.constraint(equalTo: rackNumberLabel.bottomAnchor, constant: 16),
            nameProductLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nameProductLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            nameProductLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            bookMarkButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            bookMarkButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
        ])
    }

    func config(whit item: Item) {
       let prefix = "10 "
        nameProductLabel.text = removePrefix(prefix, from: item.details.commercialName)
        rackNumberLabel.text = "\(item.location.full)"
        
    }
    private func removePrefix(_ prefix: String, from string: String) -> String {
        guard string.hasPrefix(prefix) else { return string }
        return String(string.dropFirst(prefix.count))
    }
}
