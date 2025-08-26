//
//  writeOffViewCell.swift
//  Sklad
//
//  Created by Кирилл Котыло on 19.08.25.
//

import UIKit

class WriteOffViewCell: UITableViewCell {
    
    static let reuseIdentifier = "writeOffViewCell"
    
    private let count = CountLabel(style: .writeOff)
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let projectLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.text = "Проект:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let project: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .left
        label.textColor = .systemGray
        label.text = "Количество:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let writeOffNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .left
        label.textColor = .systemGray
        label.text = "Списал:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let writeOffName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.textColor = .black
        label.text = "Котыло К."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .left
        label.textColor = .systemGray
        label.text = "Дата:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let date: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.textColor = .black
        label.text = "20.03.1996"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let separatorTop: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let restoreButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle( "Вернуть на склад", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.cornerRadius = 25
        return button
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
        addSubview(restoreButton)
        verticalStackView.addArrangedSubview(separatorTop)
        verticalStackView.addArrangedSubview(projectLabel)
        verticalStackView.addArrangedSubview(project)
        verticalStackView.addArrangedSubview(countLabel)
        verticalStackView.addArrangedSubview(count)
        verticalStackView.addArrangedSubview(writeOffNameLabel)
        verticalStackView.addArrangedSubview(writeOffName)
        verticalStackView.addArrangedSubview(dateLabel)
        verticalStackView.addArrangedSubview(date)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            restoreButton.topAnchor.constraint(equalTo: verticalStackView.bottomAnchor, constant: 16),
            restoreButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            restoreButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            restoreButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            restoreButton.heightAnchor.constraint(equalToConstant: 50),
            
            count.heightAnchor.constraint(equalToConstant: 32),
            
            separatorTop.heightAnchor.constraint(equalToConstant: 1),
            separatorTop.widthAnchor.constraint(equalTo: verticalStackView.widthAnchor)
        ])
    }
    func config(item: ItemWriteOff, isTest: Bool) {
        project.text = item.project
        if isTest {
            count.backgroundColor = .systemYellow
        }
        count.text = "\(formatNumber(item.quantity)) \(item.unit)"
        writeOffName.text = item.author
        date.text = item.date
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

