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
        label.textColor = .black
        label.backgroundColor = .clear
        label.text = "rack number"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.tintColor = .white
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
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(rackNumberLabel)
        addSubview(button)
        button.isUserInteractionEnabled = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            rackNumberLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
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
        } else {
            isSelect = false
            backgroundColor = .white
        }
        rackNumberLabel.text = "\(rack)"
    }
    
    func select() -> Bool {
        isSelect.toggle()
        switch isSelect {
        case true:
            self.deltaX -= 8
            UIView.animate(withDuration: 0.3) {
                self.backgroundColor = .systemBlue
                self.frame.size.width += 8
                self.layoutIfNeeded()
            }
        case false:
            self.deltaX += 8
            UIView.animate(withDuration: 0.3) {
                self.backgroundColor = .white
                self.frame.size.width -= 8
                self.layoutIfNeeded()
            }
        }
        return isSelect
    }
}
