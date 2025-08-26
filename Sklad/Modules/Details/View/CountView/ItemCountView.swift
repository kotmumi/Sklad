//
//  ItemCountView.swift
//  Sklad
//
//  Created by Кирилл Котыло on 18.08.25.
//

import UIKit

final class ItemCountView: UIView {
    
    private let countAvailable = CountLabel(style: .available)
    private let countTest = CountLabel(style: .test)
    private let countWriteOff = CountLabel(style: .writeOff)
    
    private let countAllLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.text = "Общее количество"
        return label
    }()
    private let countAll: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.text = "-"
        return label
    }()
    private let boxImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "box"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
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
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray6.cgColor
        layer.masksToBounds = true
        layer.cornerRadius = 16
        
        addSubview(countAvailable)
        addSubview(countTest)
        addSubview(countWriteOff)
        addSubview(countAllLabel)
        addSubview(countAll)
        addSubview(boxImageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            countAvailable.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            countAvailable.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            countAvailable.heightAnchor.constraint(equalToConstant: 32),
            countAvailable.widthAnchor.constraint(greaterThanOrEqualToConstant: 32),
            
            countTest.centerYAnchor.constraint(equalTo: countAvailable.centerYAnchor),
            countTest.leadingAnchor.constraint(equalTo: countAvailable.trailingAnchor, constant: -8),
            countTest.heightAnchor.constraint(equalToConstant: 32),
            countTest.widthAnchor.constraint(greaterThanOrEqualToConstant: 32),
            
            countWriteOff.centerYAnchor.constraint(equalTo: countTest.centerYAnchor),
            countWriteOff.leadingAnchor.constraint(equalTo: countTest.trailingAnchor, constant: -8),
            countWriteOff.heightAnchor.constraint(equalToConstant: 32),
            countWriteOff.widthAnchor.constraint(greaterThanOrEqualToConstant: 32),
            
            boxImageView.topAnchor.constraint(equalTo: countAvailable.bottomAnchor, constant: 16),
            boxImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            boxImageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            boxImageView.widthAnchor.constraint(equalToConstant: 64),
            
            countAllLabel.topAnchor.constraint(equalTo: countAvailable.bottomAnchor, constant: 16),
            countAllLabel.leadingAnchor.constraint(equalTo: boxImageView.trailingAnchor, constant: 32),
            countAllLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            countAll.topAnchor.constraint(equalTo: countAllLabel.bottomAnchor, constant: 8),
            countAll.leadingAnchor.constraint(equalTo: countAllLabel.leadingAnchor),
            countAll.trailingAnchor.constraint(equalTo: countAllLabel.trailingAnchor),
        ])
    }
    
    func config(item: Item) {
        
        let availableCount = item.stock.availableQuantity
        let testCount = item.stock.testedQuantity
        let writeOffCount = item.stock.allocatedQuantity
        let allCount = item.stock.totalQuantity
        
        countAvailable.text = formatNumber(availableCount)
        countTest.text = formatNumber(testCount)
        countWriteOff.text = formatNumber(writeOffCount)
        countAll.text = formatNumber(allCount) + " \(item.stock.unit)"
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
}
