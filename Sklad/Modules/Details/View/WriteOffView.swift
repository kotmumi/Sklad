//
//  WriteOffView.swift
//  Sklad
//
//  Created by Кирилл Котыло on 20.08.25.
//

import UIKit

final class WriteOffView: UIView {
    
    let projectPickerView = ProjectPickerView()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.text = "20 шт"
        
        let iconContainer = UIView(frame: CGRect(x: 16, y: 0, width: 40, height: 30))
        let imageView = UIImageView(image: UIImage(systemName: "pencil"))
        imageView.tintColor = .gray
        imageView.frame = CGRect(x: 8, y: 5, width: 20, height: 20)
        imageView.contentMode = .scaleAspectFit

        iconContainer.addSubview(imageView)
        textField.rightView = iconContainer
        textField.rightViewMode = .always
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    let sliderCount: UISlider = {
       let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
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
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .systemGray
        label.text = "Комментарий:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemGray5
        textField.tintColor = .systemGray
        textField.placeholder = "Примечание(не обязательно)"
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        
        let iconContainer = UIView(frame: CGRect(x: 16, y: 0, width: 40, height: 30))
        let imageView = UIImageView(image: UIImage(systemName: "pencil"))
        imageView.tintColor = .gray
        imageView.frame = CGRect(x: 8, y: 5, width: 20, height: 20)
        imageView.contentMode = .scaleAspectFit

        iconContainer.addSubview(imageView)
        textField.rightView = iconContainer
        textField.rightViewMode = .always
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        
        return textField
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
        
        backgroundColor = .white
        
        addSubview(titleLabel)
        addSubview(closeButton)
        addSubview(verticalStackView)
        addSubview(writeOffButton)
        
        verticalStackView.addArrangedSubview(separatorTop)
        verticalStackView.addArrangedSubview(countLabel)
        verticalStackView.addArrangedSubview(countTextField)
        verticalStackView.addArrangedSubview(sliderCount)
        verticalStackView.addArrangedSubview(appointmentLabel)
        verticalStackView.addArrangedSubview(segmentedControl)
        verticalStackView.addArrangedSubview(projectLabel)
        verticalStackView.addArrangedSubview(projectPickerView)
        verticalStackView.addArrangedSubview(descriptionLabel)
        verticalStackView.addArrangedSubview(descriptionTextField)
        verticalStackView.addArrangedSubview(authorLabel)
        verticalStackView.addArrangedSubview(authorTextField)
        
        countTextField.layer.cornerRadius = 25
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 32),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            closeButton.heightAnchor.constraint(equalToConstant: 40),
            closeButton.widthAnchor.constraint(equalTo: closeButton.heightAnchor),
            
            verticalStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            
            countTextField.heightAnchor.constraint(equalToConstant: 50),
            
            separatorTop.heightAnchor.constraint(equalToConstant: 1),
            separatorTop.widthAnchor.constraint(equalTo: verticalStackView.widthAnchor),
            
            sliderCount.widthAnchor.constraint(equalTo: verticalStackView.widthAnchor),
            
            segmentedControl.widthAnchor.constraint(equalTo: verticalStackView.widthAnchor),
            
            descriptionTextField.widthAnchor.constraint(equalTo: verticalStackView.widthAnchor),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 50),
            
            writeOffButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            writeOffButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            writeOffButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
            writeOffButton.heightAnchor.constraint(equalToConstant: 50),
            
            projectPickerView.widthAnchor.constraint(equalTo: verticalStackView.widthAnchor),
        ])
    }
}
