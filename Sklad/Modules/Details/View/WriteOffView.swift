//
//  WriteOffView.swift
//  Sklad
//
//  Created by Кирилл Котыло on 20.08.25.
//

import UIKit

final class WriteOffView: UIView {
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let projectPickerView = ProjectPickerView()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .buttonPrimary
        button.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        button.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .textPrimary
        label.text = "Списание"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let separatorTop: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundTertiary
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .textSecondary
        label.text = "Количество:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let countTextField = EditCountView()
    
    let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = .red
        return label
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
        label.textColor = .textSecondary
        label.text = "Назначение:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let segmentedControl = CustomSegmentedControl()

    private let projectLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .textSecondary
        label.text = "Проект:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let writeOffButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Списать", for: .normal)
        button.titleLabel?.textColor = .textPrimaryInv
        button.backgroundColor = .buttonPrimary
        button.isEnabled = false
        button.layer.cornerRadius = 25
        return button
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .textSecondary
        label.text = "Комментарий:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .backgroundTertiary
        textField.tintColor = .textSecondary
        textField.placeholder = "Примечание(не обязательно)"
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        
        let iconContainer = UIView(frame: CGRect(x: 16, y: 0, width: 40, height: 30))
        let imageView = UIImageView(image: UIImage(systemName: "pencil"))
        imageView.tintColor = .textSecondary
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
        label.textColor = .textSecondary
        label.text = "Сотрудник:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let userView = UserView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.backgroundColor = .backgroundTertiary
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        backgroundColor = .backgroundSecondary
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(closeButton)
        contentView.addSubview(verticalStackView)
        contentView.addSubview(userView)
        addSubview(writeOffButton)
        
        verticalStackView.addArrangedSubview(separatorTop)
        verticalStackView.addArrangedSubview(countLabel)
        verticalStackView.addArrangedSubview(countTextField)
        verticalStackView.addArrangedSubview(errorLabel)
        verticalStackView.addArrangedSubview(sliderCount)
        verticalStackView.addArrangedSubview(appointmentLabel)
        verticalStackView.addArrangedSubview(segmentedControl)
        verticalStackView.addArrangedSubview(projectLabel)
        verticalStackView.addArrangedSubview(projectPickerView)
        verticalStackView.addArrangedSubview(descriptionLabel)
        verticalStackView.addArrangedSubview(descriptionTextField)
        verticalStackView.addArrangedSubview(authorLabel)
        
        countTextField.layer.cornerRadius = 25
        countTextField.layer.borderColor = UIColor.backgroundTertiary.cgColor
        countTextField.layer.borderWidth = 1
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: writeOffButton.topAnchor, constant: -8),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            closeButton.heightAnchor.constraint(equalToConstant: 50),
            closeButton.widthAnchor.constraint(equalTo: closeButton.heightAnchor),
            
            verticalStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            
            countTextField.heightAnchor.constraint(equalToConstant: 50),
            countTextField.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            
            separatorTop.heightAnchor.constraint(equalToConstant: 1),
            separatorTop.widthAnchor.constraint(equalTo: verticalStackView.widthAnchor),
            
            sliderCount.widthAnchor.constraint(equalTo: verticalStackView.widthAnchor),
            
            segmentedControl.widthAnchor.constraint(equalTo: verticalStackView.widthAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 40),
            
            descriptionTextField.widthAnchor.constraint(equalTo: verticalStackView.widthAnchor),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 50),
            
            writeOffButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            writeOffButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            writeOffButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
            writeOffButton.heightAnchor.constraint(equalToConstant: 50),
            
            projectPickerView.widthAnchor.constraint(equalTo: verticalStackView.widthAnchor),
            
            userView.topAnchor.constraint(equalTo: verticalStackView.bottomAnchor, constant: 16),
            userView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            userView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            userView.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.bottomAnchor, constant: -16),
        ])
    }
}
