//
//  FilterCell.swift
//  StockTrace
//
//  Created by Кирилл Котыло on 4.07.25.
//

import UIKit

class FilterCell: UICollectionViewCell {
    
    static let identifier: String = "FilterCell"
    private var deltaX: CGFloat = 0
    var isSelect: Bool = false
    
    private let rackNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .textPrimary
        label.backgroundColor = .clear
        label.text = "rack number"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.tintColor = .buttonFilter
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
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
        backgroundColor = .buttonFilter
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(rackNumberLabel)
        addSubview(button)
        button.isUserInteractionEnabled = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            rackNumberLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 19),
            rackNumberLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 12),
            button.heightAnchor.constraint(equalToConstant: 12),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }

    func config (from rack: String, _ isActive: Bool) {
        if isActive {
            isSelect = true
            _ = select()
            frame.size.width += 16
        } else {
            isSelect = false
            backgroundColor = .buttonFilter
            rackNumberLabel.textColor = .textPrimary
        }
        rackNumberLabel.text = "\(rack)"
    }
    
    func select() -> Bool {
        isSelect.toggle()
        switch isSelect {
        case true:
            self.deltaX -= 16
            UIView.animate(withDuration: 0.3) {
                self.backgroundColor = .buttonPrimary
                self.rackNumberLabel.textColor = .textPrimaryInv
                self.frame.size.width += 16
                self.layoutIfNeeded()
            }
        case false:
            self.deltaX += 16
            UIView.animate(withDuration: 0.3) {
                self.backgroundColor = .buttonFilter
                self.rackNumberLabel.textColor = .textPrimary
                self.frame.size.width -= 16
                self.layoutIfNeeded()
            }
        }
        return isSelect
    }
}
