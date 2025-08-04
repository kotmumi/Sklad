//
//  CustomNavigationBar.swift
//  Sklad
//
//  Created by Кирилл Котыло on 3.08.25.
//
import UIKit

class CustomNavigationBar: UINavigationBar {
    
    let bottomView = CustomSegmentedControlView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        addSubview(bottomView)
        
        NSLayoutConstraint.activate([
            bottomView.topAnchor.constraint(equalTo: bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Увеличиваем высоту NavigationBar
        let newHeight = frame.height + 50
        frame.size.height = newHeight
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let superSize = super.sizeThatFits(size)
        return CGSize(width: superSize.width, height: superSize.height + 50)
    }
}
