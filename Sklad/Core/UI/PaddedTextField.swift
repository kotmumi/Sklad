//
//  PaddedTextField.swift
//  Sklad
//
//  Created by Кирилл Котыло on 6.09.25.
//
import UIKit

class PaddedTextField: UITextField {
    var textPadding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
}
