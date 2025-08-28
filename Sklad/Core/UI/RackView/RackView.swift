//
//  RackView.swift
//  Sklad
//
//  Created by Кирилл Котыло on 27.08.25.
//

import UIKit

final class RackView: UIView {
    
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
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .rackBack
        layer.cornerRadius = 12
        layer.masksToBounds = true
        addSubview(rackNumberLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
         
            heightAnchor.constraint(equalToConstant: 24),
            widthAnchor.constraint(greaterThanOrEqualToConstant:24),
            
            rackNumberLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            rackNumberLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            rackNumberLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
        ])
    }
    
    func config(rack: String) {
        rackNumberLabel.text = rack
        
    }
}
