//
//  FilterView.swift
//  StockTrace
//
//  Created by Кирилл Котыло on 2.07.25.
//

import UIKit

class FilterView: UIView {
    
   
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .systemGroupedBackground
        return stackView
    }()
    
    let RactsCharCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 8
            layout.minimumInteritemSpacing = 10
            return layout
        }()
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGroupedBackground
        return view
    }()
    
    let acceptButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Применить фильтр", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        button.tintColor = .white
        button.backgroundColor = .black
        button.layer.cornerRadius = 25
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemGroupedBackground
        addSubview(RactsCharCollectionView)
        addSubview(acceptButton)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            RactsCharCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 32),
            RactsCharCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 8),
            RactsCharCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -8),
            RactsCharCollectionView.bottomAnchor.constraint(equalTo: acceptButton.topAnchor, constant: -32),
            
            acceptButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -50),
            acceptButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            acceptButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            acceptButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
}
