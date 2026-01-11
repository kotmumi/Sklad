//
//  Checkbox.swift
//  Sklad
//
//  Created by Кирилл Котыло on 24.09.25.
//

import UIKit

class Checkbox: UIButton {
    private let checkedImage = UIImage(systemName: "checkmark.circle.fill")
    private let uncheckedImage = UIImage(systemName: "circle")
    
    var isChecked: Bool = false {
        didSet {
            updateAppearance()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        setImage(uncheckedImage, for: .normal)
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        tintColor = .buttonPrimary
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc private func buttonTapped() {
        isChecked.toggle()
    }
    
    private func updateAppearance() {
        let image = isChecked ? checkedImage : uncheckedImage
        setImage(image, for: .normal)
    }
}
