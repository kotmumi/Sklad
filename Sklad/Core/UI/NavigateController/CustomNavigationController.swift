//
//  CustomNavigationController.swift
//  StockTrace
//
//  Created by Кирилл Котыло on 25.06.25.
//

import UIKit

class CustomNavigationController: UINavigationController {
    
    let filterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        button.tintColor = .black
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 25
        return button
    }()
    
    let searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchBar.placeholder = "Поиск по названию"
        sc.searchBar.searchTextField.backgroundColor = .white
        sc.searchBar.searchTextField.layer.cornerRadius = 10
        sc.searchBar.searchTextField.clipsToBounds = true
        return sc
    }()
    
    var isSearchBarHidden: Bool = false {
           didSet {
               updateSearchBarVisibility()
           }
       }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        setupNavigationBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNavigationBar() {
        // 1. Настраиваем внешний вид navigationBar
        navigationBar.prefersLargeTitles = false
        navigationBar.tintColor = .black
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .background
        appearance.shadowColor = .clear
        
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        
        // 2. Добавляем searchController к текущему navigationItem
        topViewController?.navigationItem.searchController = searchController
        topViewController?.navigationItem.hidesSearchBarWhenScrolling = false
        
        // 3. Добавляем кастомную кнопку в searchBar
     //   setupSearchBarAppearance()
    }
    
    private func updateSearchBarVisibility() {
           if isSearchBarHidden {
               topViewController?.navigationItem.searchController = nil
               topViewController?.navigationItem.hidesSearchBarWhenScrolling = true
           } else {
               topViewController?.navigationItem.searchController = searchController
               topViewController?.navigationItem.hidesSearchBarWhenScrolling = false
           }
       }
    
//    private func setupSearchBarAppearance() {
//        // Добавляем filterButton прямо в searchBar
//        searchController.searchBar.addSubview(filterButton)
//        
//        NSLayoutConstraint.activate([
//            filterButton.heightAnchor.constraint(equalToConstant: 50),
//            filterButton.widthAnchor.constraint(equalToConstant: 50),
//            filterButton.trailingAnchor.constraint(equalTo: searchController.searchBar.trailingAnchor, constant: -16),
//            filterButton.centerYAnchor.constraint(equalTo: searchController.searchBar.centerYAnchor)
//        ])
    //}
    
    // Обновляем при смене ViewController'ов
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        updateSearchController(for: viewController)
    }
    
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        if let topVC = viewControllers.last {
            updateSearchController(for: topVC)
        }
    }
    
    private func updateSearchController(for viewController: UIViewController) {
        // Переносим searchController на новый ViewController
        viewController.navigationItem.searchController = searchController
        viewController.navigationItem.hidesSearchBarWhenScrolling = false
    }
}
