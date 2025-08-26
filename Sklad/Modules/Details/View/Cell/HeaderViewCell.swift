//
//  HeaderViewCell.swift
//  Sklad
//
//  Created by Кирилл Котыло on 18.08.25.
//

import UIKit

final class HeaderViewCell: UITableViewCell {
    
    static let reuseIdentifier = "HeaderViewCell"
    
    private let itemCount = ItemCountView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(itemCount)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            itemCount.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            itemCount.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            itemCount.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            itemCount.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    func config(item: Item) {
        itemCount.config(item: item)
    }
}
