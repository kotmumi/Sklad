//
//  CustomNavigationController.swift
//  StockTrace
//
//  Created by Кирилл Котыло on 25.06.25.
//

import UIKit

class CustomNavigationController: UINavigationController {

    let searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchBar.placeholder = "Поиск по названию"
        sc.searchBar.searchTextField.backgroundColor = .white
        sc.searchBar.searchTextField.layer.cornerRadius = 25
        sc.searchBar.searchTextField.clipsToBounds = true
        return sc
    }()
    
    var trailingPadding: CGFloat = 16 {
           didSet {
               trailingConstraint?.constant = -trailingPadding
               if trailingPadding == 16 {
                   leadingConstraint?.constant = trailingPadding
               }
               UIView.animate(withDuration: 0.3) {
                   self.view.layoutIfNeeded()
               }
           }
       }
    
    private var trailingConstraint: NSLayoutConstraint?
    private var leadingConstraint: NSLayoutConstraint?
    
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
        navigationBar.prefersLargeTitles = false
        navigationBar.tintColor = .black
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .background
        appearance.shadowColor = .clear
        
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        
        topViewController?.navigationItem.searchController = searchController
        topViewController?.navigationItem.hidesSearchBarWhenScrolling = false
        
        DispatchQueue.main.async {
                    self.setupSearchBarAppearance()
        }
        
    }
    
    private func setupSearchBarAppearance() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
             let searchTextField = self.searchController.searchBar.searchTextField
             
             searchTextField.backgroundColor = .white
             searchTextField.layer.cornerRadius = 25
             searchTextField.clipsToBounds = true
             
             searchTextField.translatesAutoresizingMaskIntoConstraints = false
             
            self.trailingConstraint = searchTextField.trailingAnchor.constraint(
                        equalTo: self.navigationBar.trailingAnchor,
                        constant: -self.trailingPadding
                    )
            
            self.leadingConstraint = searchTextField.leadingAnchor.constraint(
                equalTo: self.navigationBar.leadingAnchor,
                constant: self.trailingPadding
            )
            
             NSLayoutConstraint.activate([
                 searchTextField.heightAnchor.constraint(equalToConstant: 50),
                 searchTextField.widthAnchor.constraint(equalTo: self.searchController.searchBar.widthAnchor, constant: -32),
                 self.leadingConstraint!,
                 self.trailingConstraint!
             ])
             
            self.searchController.searchBar.layoutIfNeeded()
         }
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
    
    private func updateSearchController(for viewController: UIViewController) {
        trailingPadding = 16
        viewController.navigationItem.searchController = searchController
        viewController.navigationItem.hidesSearchBarWhenScrolling = false
    }
}
