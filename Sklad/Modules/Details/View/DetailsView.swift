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
    private let itemCount = ItemCountView()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        return tableView
    }()
    
    let writeOffButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.setTitle("Списать", for: .normal)
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
        backgroundColor = .background
        addSubview(segmentedControl)
        segmentedControl.segmentedControl.roundCorners(radius: 25)
        addSubview(tableView)
        addSubview(writeOffButton)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HeaderViewCell.self, forCellReuseIdentifier: HeaderViewCell.reuseIdentifier)
        tableView.register(InfoViewCell.self, forCellReuseIdentifier: InfoViewCell.reuseIdentifier)
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

extension DetailsView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let headerCell = tableView.dequeueReusableCell(withIdentifier: HeaderViewCell.reuseIdentifier, for: indexPath) as? HeaderViewCell else {
            return UITableViewCell()
        }
        
        guard let infoCell = tableView.dequeueReusableCell(withIdentifier: InfoViewCell.reuseIdentifier, for: indexPath) as? InfoViewCell else {
            return UITableViewCell()
        }
        switch indexPath.row {
            case 0:
            return headerCell
        default:
            return infoCell
        }
    }
}

extension DetailsView: UITableViewDelegate {
    
}

#Preview {
    DetailsViewController()
}
