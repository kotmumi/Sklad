//
//  CountView.swift
//  Sklad
//
//  Created by Кирилл Котыло on 18.08.25.
//

import UIKit

final class CountLabel: UILabel {

    private let leftInset: CGFloat = 12
    private let rightInset: CGFloat = 12
    
    private let style: CountStyle
    
    init(style: CountStyle) {
        self.style = style
        super.init(frame: .zero)
        setupSettings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
           super.drawText(in: rect.inset(by: insets))
       }
    
    override var intrinsicContentSize: CGSize {
            let size = super.intrinsicContentSize
            return CGSize(
                width: size.width + leftInset + rightInset,
                height: size.height
            )
    }
    
    private func setupSettings() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = style.color
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = 16
        layer.masksToBounds = true
        textColor = .white
        textAlignment = .left
        font = .systemFont(ofSize: 14, weight: .regular)
        text = "-"
    }
}

enum CountStyle {
    case available
    case test
    case writeOff
    
    var color: UIColor {
        switch self {
        case .available: return .systemGreen
        case .test: return .systemYellow
        case .writeOff: return .systemRed
        }
    }
}
