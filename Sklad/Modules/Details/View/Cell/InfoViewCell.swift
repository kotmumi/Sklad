//
//  InfoViewCell.swift
//  Sklad
//
//  Created by Кирилл Котыло on 18.08.25.
//

import UIKit

final class InfoViewCell: UITableViewCell {
    
    static let reuseIdentifier = "InfoViewCell"
    
    private let priceView = PriceView()
    private let count = CountLabel(style: .available)
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.text = "Номенклатура:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let name: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let actualNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.text = "Номенклатура фактическая:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let actualName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let separatorTop: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let separatorBottom: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .left
        label.textColor = .systemGray
        label.text = "Доступное количество:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .left
        label.textColor = .systemGray
        label.text = "Комментарий:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let comment: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(separatorTop)
        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(name)
        verticalStackView.addArrangedSubview(actualNameLabel)
        verticalStackView.addArrangedSubview(actualName)
        verticalStackView.addArrangedSubview(priceView)
        verticalStackView.addArrangedSubview(separatorBottom)
        verticalStackView.addArrangedSubview(countLabel)
        verticalStackView.addArrangedSubview(count)
        verticalStackView.addArrangedSubview(commentLabel)
        verticalStackView.addArrangedSubview(comment)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            count.widthAnchor.constraint(greaterThanOrEqualToConstant: 32),
            count.heightAnchor.constraint(equalToConstant: 32),
            
            separatorTop.heightAnchor.constraint(equalToConstant: 1),
            separatorTop.widthAnchor.constraint(equalTo: verticalStackView.widthAnchor),
            
            separatorBottom.heightAnchor.constraint(equalToConstant: 1),
            separatorBottom.widthAnchor.constraint(equalTo: verticalStackView.widthAnchor)
        ])
    }
    
    func config(item: Item) {
        name.text = item.details.commercialName
        actualName.text = item.details.technicalName
        count.text = "\(formatNumber(item.stock.availableQuantity)) \(item.stock.unit)"
        comment.text = item.details.discription
        priceView.config(item: item)
    }
}

func formatNumber(_ value: Double) -> String {
    if value.truncatingRemainder(dividingBy: 1) == 0 {
        if value == 0.0 {
            return "-"
        }
        return String(Int(value))
    } else {
        return String(value)
    }
}
