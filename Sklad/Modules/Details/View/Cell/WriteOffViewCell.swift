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
    private var restoreAction: (() -> Void)?
    
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
        label.textColor = .textSecondary
        label.text = "Проект:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let project: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .left
        label.textColor = .textSecondary
        label.text = "Количество:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let writeOffNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .left
        label.textColor = .textSecondary
        label.text = "Списал:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let writeOffName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.textColor = .textPrimary
        label.text = "Котыло К."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .left
        label.textColor = .textSecondary
        label.text = "Дата:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let date: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.textColor = .textPrimary
        label.text = "20.03.1996"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let discriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .left
        label.textColor = .textSecondary
        label.text = "Примечание:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let discription: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.textColor = .textPrimary
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let separatorTop: UIView = {
        let view = UIView()
        view.backgroundColor = .textSecondary
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let restoreButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle( "Вернуть на склад", for: .normal)
        button.setTitleColor(.buttonPrimary, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.buttonPrimary.cgColor
        button.layer.cornerRadius = 25
        button.isUserInteractionEnabled = true
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
      override func prepareForReuse() {
          super.prepareForReuse()
          restoreAction = nil
      }
      
      private func setupButton() {
          restoreButton.addTarget(self, action: #selector(restoreButtonTapped), for: .touchUpInside)
      }
    
    @objc private func restoreButtonTapped() {
         restoreAction?()
     }
    
    private func setupUI() {
        backgroundColor = .backgroundSecondary
        selectionStyle = .none
        contentView.addSubview(verticalStackView)
        contentView.addSubview(restoreButton)
        verticalStackView.addArrangedSubview(separatorTop)
        verticalStackView.addArrangedSubview(dateLabel)
        verticalStackView.addArrangedSubview(date)
        verticalStackView.addArrangedSubview(projectLabel)
        verticalStackView.addArrangedSubview(project)
        verticalStackView.addArrangedSubview(countLabel)
        verticalStackView.addArrangedSubview(count)
        verticalStackView.addArrangedSubview(writeOffNameLabel)
        verticalStackView.addArrangedSubview(writeOffName)
        verticalStackView.addArrangedSubview(discriptionLabel)
        verticalStackView.addArrangedSubview(discription)
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            restoreButton.topAnchor.constraint(equalTo: verticalStackView.bottomAnchor, constant: 16),
            restoreButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            restoreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            restoreButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            restoreButton.heightAnchor.constraint(equalToConstant: 50),
            
            count.heightAnchor.constraint(equalToConstant: 32),
            
            separatorTop.heightAnchor.constraint(equalToConstant: 1),
            separatorTop.widthAnchor.constraint(equalTo: verticalStackView.widthAnchor)
        ])
    }
    func config(item: ItemWriteOff, isTest: Bool, onRestore: @escaping () -> Void, last: Bool = false) {
        project.text = item.project
        if isTest {
            count.backgroundColor = .systemYellow
        }
        count.text = "\(formatNumber(item.quantity)) \(item.unit)"
        writeOffName.text = item.author
        date.text = item.date
        discription.text = item.comment ?? ""
        self.restoreAction = onRestore
        
       // if last {
          //  layer.cornerRadius = 24
           // layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
           // layer.masksToBounds = true
       // }
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

