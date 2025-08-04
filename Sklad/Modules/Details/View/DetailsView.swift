//
//  DetailsView.swift
//  Sklad
//
//  Created by Кирилл Котыло on 3.08.25.
//

import UIKit

class DetailsView: UIView {
    
    //private let item: Item
    
    private let segmentedControl = CustomSegmentedControlView()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Детали"
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
//    private let segmentedControl: UISegmentedControl = {
//        let segment = UISegmentedControl(items: ["Активный","На тесте","Списанное"])
//        segment.selectedSegmentIndex = 0
//        segment.translatesAutoresizingMaskIntoConstraints = false
//        segment.setImage(UIImage(systemName: "chevron.down"), forSegmentAt: 0)
//        return segment
//    }()
    
//    init() {//item: Item) {
//       // self.item = item
//        super.init(frame: .zero)
//        setupUI()
//        setConstraints()
//    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        addSubview(segmentedControl)
        segmentedControl.segmentedControl.roundCorners(radius: 25)
        addSubview(label)
    }
    private func setConstraints() {
        NSLayoutConstraint.activate([
          
            segmentedControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

#Preview {
    DetailsViewController()
}
