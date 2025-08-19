//
//  ItemPriceView.swift
//  Sklad
//
//  Created by Кирилл Котыло on 18.08.25.
//

import UIKit

class ItemPriceView: UIStackView {
    
    private let isTotalPrice: Bool
    private let totalPrice = "Сумма,руб.:"
    private let price = "Цена,руб.:"
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .center
        label.textColor = .lightGray
        label.text = "Цена,руб.:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(_ isTotalPrice: Bool) {
        self.isTotalPrice = isTotalPrice
        super.init(frame: .zero)
        setupUI()
        setupConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        axis = .vertical
        spacing = 8
        addArrangedSubview(label)
        addArrangedSubview(priceContainerView)
        priceContainerView.addSubview(priceLabel)
        label.text = isTotalPrice ? totalPrice : price
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            priceLabel.centerYAnchor.constraint(equalTo: priceContainerView.centerYAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: priceContainerView.leadingAnchor, constant: 8),
            priceLabel.trailingAnchor.constraint(equalTo: priceContainerView.trailingAnchor, constant: -8),
            
            priceContainerView.widthAnchor.constraint(greaterThanOrEqualToConstant: 32),
            priceContainerView.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
}

