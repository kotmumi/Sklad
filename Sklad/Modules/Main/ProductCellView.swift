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
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "name product"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGroupedBackground
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    
    private let rackNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .black
        label.backgroundColor = .systemGroupedBackground
        label.textAlignment = .center
        label.text = "rack number"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        layer.cornerRadius = 25
        addSubview(nameProductLabel)
        addSubview(containerView)
        containerView.addSubview(rackNumberLabel)
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
        ])
    }

    func config(whit item: Item) {
       let prefix = "10 "
      //  nameProductLabel.text = removePrefix(prefix, from: item.name)
    //    rackNumberLabel.text = "\(item.category)"
        
    }
    private func removePrefix(_ prefix: String, from string: String) -> String {
        guard string.hasPrefix(prefix) else { return string }
        return String(string.dropFirst(prefix.count))
    }
}
