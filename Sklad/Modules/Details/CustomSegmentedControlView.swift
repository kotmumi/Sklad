//
//  CustomSegmentControl.swift
//  Sklad
//
//  Created by Кирилл Котыло on 3.08.25.
//

import UIKit

class CustomSegmentedControlView: UIView {
    
     let segmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Активный", "На тесте", "Списанное"])
        segment.selectedSegmentIndex = 0
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.layer.cornerRadius = 16
        return segment
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .background

        addSubview(segmentedControl)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([

            // Segmented Control
            segmentedControl.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            segmentedControl.heightAnchor.constraint(equalToConstant: 32),
            segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            segmentedControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
        ])
    }
   }

extension UISegmentedControl {
    func roundCorners(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}
