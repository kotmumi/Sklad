//
//  WriteOffViewController.swift
//  Sklad
//
//  Created by Кирилл Котыло on 20.08.25.
//

import UIKit
import Combine

final class WriteOffViewController: UIViewController {
    
    let writeOffView = WriteOffView()
    var coordinator: DetailsCoordinator?
    private let viewModel: DetailsViewModel
    private var status: StatusItem = .inTest
    private var cancellables: Set<AnyCancellable> = []
    
    init(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = writeOffView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        bindViewAction()
        setupKeyboardForTextFields()
    }
}

extension WriteOffViewController {
    
    private func bind() {
        viewModel.project
            .receive(on: DispatchQueue.main)
            .sink { [weak self] project in
                guard let project = project else { return }
                self?.writeOffView.projectPickerView.config(with: project)
            }
            .store(in: &cancellables)
        
        viewModel.countItem
            .receive(on: DispatchQueue.main)
            .sink { [weak self] count in
                if count > self?.viewModel.item.stock.availableQuantity ?? 0 {
                    self?.writeOffView.countTextField.layer.borderColor = UIColor.red.cgColor
                    self?.writeOffView.errorLabel.text = "Не допустимое количество"
                } else {
                    self?.writeOffView.countTextField.layer.borderColor = UIColor.lightGray.cgColor
                    self?.writeOffView.errorLabel.text = ""
                }
                self?.writeOffView.countTextField.countTextField.text = self?.formatNumber(count)
                self?.writeOffView.sliderCount.value = Float(count)
            }
            .store(in: &cancellables)
            
        viewModel.isSelectUser
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isSelect in
                guard let self else {return }
                if isSelect {
                    self.viewModel.usersInTable = self.viewModel.users
                } else {
                    self.viewModel.usersInTable = self.viewModel.users.filter {$0.name == self.viewModel.user?.name }
                }
                self.writeOffView.userView.tapImage(isOpen: isSelect)
                self.writeOffView.userView.userTableView.reloadData()
                self.writeOffView.userView.updateTableViewHeight()
                let location = writeOffView.frame.size.height - writeOffView.userView.frame.maxY - 258
                var bottomOffset = CGPoint(x: 0, y: abs(location))
                if !isSelect {
                    bottomOffset = CGPoint(x: 0, y: 0)
                }
                self.writeOffView.scrollView.setContentOffset(bottomOffset, animated: true)
                print(isSelect)
            }
            .store(in: &cancellables)
        
        viewModel.isButtonEnable
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEnable in
                UIView.animate(withDuration: 0.3) {
                    self?.writeOffView.writeOffButton.isEnabled = isEnable
                    self?.writeOffView.writeOffButton.backgroundColor = isEnable ? .buttonPrimary : .backgroundTertiary
                }
            }
            .store(in: &cancellables)
    }
    
    private func bindViewAction() {
        let segmentedControl = writeOffView.segmentedControl
        
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
    }
    
    @objc private func segmentedControlValueChanged(_ sender: CustomSegmentedControl) {
        viewModel.segmentWriteOffChanged.send(sender.selectedSegment.rawValue + 1)
    }
    
    private func setupUI() {
        writeOffView.countTextField.tag = 0
        writeOffView.descriptionTextField.tag = 1
        navigationController?.navigationBar.isHidden = true
        
        writeOffView.closeButton.addAction(UIAction { [weak self] _ in
            self?.coordinator?.close()
        }, for: .touchUpInside)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer))
        writeOffView.projectPickerView.addGestureRecognizer(tapGestureRecognizer)
        
        let tapUserGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapUserGestureRecognizer))
        writeOffView.userView.containerView.addGestureRecognizer(tapUserGestureRecognizer)
        
        let tapEditCountViewGesture = UITapGestureRecognizer(target: self, action: #selector(handleEditCount))
        writeOffView.countTextField.addGestureRecognizer(tapEditCountViewGesture)
        
        writeOffView.sliderCount.maximumValue = Float(viewModel.item.stock.availableQuantity)
        writeOffView.sliderCount.minimumValue = 0
        
        writeOffView.sliderCount.addTarget(self, action: #selector(handleValueChangedSlider), for: .valueChanged)
        writeOffView.countTextField.countTextField.delegate = self
        writeOffView.descriptionTextField.delegate = self
        writeOffView.userView.userTableView.dataSource = self
        writeOffView.userView.userTableView.delegate = self
        writeOffView.userView.updateTableViewHeight()
        
        writeOffView.userView.userTableView.register(UserViewCell.self, forCellReuseIdentifier: UserViewCell.reuseIdentifier)
        
        writeOffView.writeOffButton.addAction(UIAction { [weak self] _ in
            Task {
                self?.coordinator?.close()
                self?.coordinator?.showWriteOffAlert(self?.viewModel.item.details.commercialName ?? "", self?.viewModel.countItem.value ?? 0)
                try await self?.viewModel.writeOff()
            }
        }, for: .touchUpInside)
    }
    
    @objc
    private func handleValueChangedSlider() {
        let count = Double(ceil(writeOffView.sliderCount.value)) < viewModel.item.stock.availableQuantity ? Double(ceil(writeOffView.sliderCount.value)) : viewModel.item.stock.availableQuantity
        viewModel.countItem.send(count)
    }
    
    @objc
    private func handleEditCount() {
        writeOffView.countTextField.countTextField.becomeFirstResponder()
    }
    
    @objc
    private func handleTapGestureRecognizer() {
        coordinator?.goToProjectView()
    }
    
    @objc
    private func handleTapUserGestureRecognizer() {
        viewModel.isSelectUser.send(!viewModel.isSelectUser.value)
    }
    
    private func setupKeyboardForTextFields() {
        // Создаём toolbar с кнопкой Done
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        toolbar.setItems([flexSpace, doneButton], animated: false)
        
        // Привязываем toolbar к текстовому полю с цифрами
        //writeOffView.countTextField.inputAccessoryView = toolbar
        writeOffView.countTextField.countTextField.inputAccessoryView = toolbar
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
           tapGesture.cancelsTouchesInView = false // чтобы тап по кнопкам/сегменту тоже работал
           view.addGestureRecognizer(tapGesture)

    }

    @objc private func doneTapped() {
        writeOffView.countTextField.countTextField.resignFirstResponder() // Скрываем клавиатуру
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true) // скроет клавиатуру для всех UITextField на экране
    }
    
}

extension WriteOffViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        
        if let nextTextField = view.viewWithTag(nextTag) as? UITextField {
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        //guard let tag = textField.tag else { return }
        switch textField.tag {
        case 0 :
            guard let count = Double(textField.text ?? "") else { return }
            viewModel.countItem.send(count)
        case 1 :
            viewModel.descriptionItem.send(textField.text ?? "")
        default:
            return
        }
        textField.resignFirstResponder()
    }
}

extension WriteOffViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.usersInTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserViewCell.reuseIdentifier, for: indexPath) as? UserViewCell else { return UITableViewCell() }
        if viewModel.usersInTable.count > 0 {
            cell.config(user: viewModel.usersInTable[indexPath.row], isSelected: viewModel.user?.name == viewModel.usersInTable[indexPath.row].name)
        }
        return cell
    }
}

extension WriteOffViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if viewModel.user?.name != viewModel.usersInTable[indexPath.row].name {
            viewModel.user = viewModel.usersInTable[indexPath.row]
        } else {
            viewModel.user = nil
        }
        viewModel.isSelectUser.send(false)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func formatNumber(_ value: Double) -> String {
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            return String(Int(value))
        } else {
            return String(value)
        }
    }
}
