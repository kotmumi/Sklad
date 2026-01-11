//
//  DetailsView.swift
//  Sklad
//
//  Created by Кирилл Котыло on 3.08.25.
//

import UIKit

class DetailsView: UIView {
    
    let segmentedControl = CustomSegmentedControlView()
    private let itemCount = ItemCountView()
    
    let statusView = StatusIndicatorView()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 24
        tableView.separatorStyle = .none
        tableView.backgroundColor = .backgroundPrimary
        return tableView
    }()
    
    let writeOffButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .buttonPrimary
        button.setTitle("Списать", for: .normal)
        button.tintColor = .textPrimary
        button.layer.cornerRadius = 25
        return button
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
        backgroundColor = .backgroundPrimary
        segmentedControl.segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(segmentedControl)
        addSubview(statusView)
        //segmentedControl.segmentedControl.roundCorners(radius: 25)
        addSubview(tableView)
        addSubview(writeOffButton)
  
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
          
            segmentedControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
        
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -82),
            writeOffButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            writeOffButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            writeOffButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            writeOffButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
