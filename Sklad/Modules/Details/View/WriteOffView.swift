//
//  WriteOffView.swift
//  Sklad
//
//  Created by Кирилл Котыло on 20.08.25.
//

import UIKit

final class WriteOffView: UIView {
    
    private let projectPickerView = ProjectPickerView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .black
        label.text = "Списание"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let separatorTop: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.text = "Количество:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let countTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.text = "20 шт"
        textField.rightView = UIImageView(image: UIImage(systemName: "pencil"))
        textField.rightViewMode = .always
        return textField
    }()
    
    private let appointmentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.text = "Назначение:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let segmentedControl: UISegmentedControl = {
       let segment = UISegmentedControl(items: ["На тесты", "На списание"])
       segment.selectedSegmentIndex = 0
       segment.translatesAutoresizingMaskIntoConstraints = false
       segment.layer.cornerRadius = 16
       return segment
   }()
    
    private let projectLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.text = "Проект:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let writeOffButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Списать", for: .normal)
        button.titleLabel?.textColor = .systemGray
        button.backgroundColor = .lightGray
        button.isEnabled = false
        button.layer.cornerRadius = 25
        return button
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.text = "Сотрудник:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let authorTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.rightView = UIImageView(image: UIImage(systemName: "pencil"))
        textField.rightViewMode = .always
        textField.placeholder = "Кто списывает"
        return textField
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
        backgroundColor = .background
        addSubview(titleLabel)
        addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(separatorTop)
        verticalStackView.addArrangedSubview(countLabel)
        verticalStackView.addArrangedSubview(countTextField)
        verticalStackView.addArrangedSubview(appointmentLabel)
        verticalStackView.addArrangedSubview(segmentedControl)
        verticalStackView.addArrangedSubview(projectLabel)
        verticalStackView.addArrangedSubview(projectPickerView)
        verticalStackView.addArrangedSubview(authorLabel)
        verticalStackView.addArrangedSubview(authorTextField)
        addSubview(writeOffButton)
        countTextField.layer.cornerRadius = 16
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            verticalStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            
            countTextField.heightAnchor.constraint(equalToConstant: 32),
            
            separatorTop.heightAnchor.constraint(equalToConstant: 1),
            separatorTop.widthAnchor.constraint(equalTo: verticalStackView.widthAnchor),
            
            segmentedControl.widthAnchor.constraint(equalTo: verticalStackView.widthAnchor),
            
            
            writeOffButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            writeOffButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            writeOffButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
            writeOffButton.heightAnchor.constraint(equalToConstant: 50),
            
            projectPickerView.widthAnchor.constraint(equalTo: verticalStackView.widthAnchor),
        ])
    }
}
