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
        sc.searchBar.searchTextField.backgroundColor = .backgroundTertiary
        sc.searchBar.searchTextField.layer.cornerRadius = 25
        sc.searchBar.searchTextField.clipsToBounds = true
        sc.searchBar.searchTextField.rightView = UIImageView(image: UIImage(systemName: "xmark.circle.fill"))
        sc.searchBar.searchTextField.rightViewMode = .unlessEditing
        return sc
    }()
    
    let scannerButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        button.setTitle("QR", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setImage(UIImage(systemName: "qrcode"), for: .normal)
        button.tintColor = .textSecondary
        button.backgroundColor = .buttonTertiary
        return button
    }()
    
    var trailingPadding: CGFloat = 24 {
           didSet {
               trailingConstraint?.constant = -trailingPadding
               if trailingPadding == 24 {
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
        navigationBar.tintColor = .buttonPrimary
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .backgroundPrimary
        appearance.shadowColor = .clear
        
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        
        topViewController?.navigationItem.searchController = searchController
        topViewController?.navigationItem.hidesSearchBarWhenScrolling = false
        
        //DispatchQueue.main.async {
        //    self.setupSearchBarAppearance()
        //}
    }
    
    func setupSearchBarAppearance() {
        DispatchQueue.main.async { [weak self] in
            
             guard let self else { return }
            
            self.searchController.searchBar.addSubview(scannerButton)
            
             let searchTextField = self.searchController.searchBar.searchTextField
             searchTextField.backgroundColor = .backgroundTertiary
             searchTextField.layer.cornerRadius = 25
             searchTextField.clipsToBounds = true
             searchTextField.translatesAutoresizingMaskIntoConstraints = false
            
            self.trailingConstraint = searchTextField.trailingAnchor.constraint(
                        equalTo: self.navigationBar.trailingAnchor,
                        constant: -self.trailingPadding
                    )
            
            self.leadingConstraint = searchTextField.leadingAnchor.constraint(
                equalTo: self.navigationBar.leadingAnchor,
                constant: 16//self.trailingPadding
            )
            
             NSLayoutConstraint.activate([
                 searchTextField.heightAnchor.constraint(equalToConstant: 50),
                 searchTextField.widthAnchor.constraint(equalTo:self.searchController.searchBar.widthAnchor, constant: -32),
                 self.leadingConstraint!,
                 self.trailingConstraint!,
                 
                 scannerButton.heightAnchor.constraint(equalToConstant: 40),
                 scannerButton.widthAnchor.constraint(equalToConstant: 80),
                 scannerButton.trailingAnchor.constraint(equalTo: searchTextField.trailingAnchor, constant: -5),
                 scannerButton.topAnchor.constraint(equalTo: searchTextField.topAnchor, constant: 5),
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
        trailingPadding = 24
        viewController.navigationItem.searchController = searchController
        viewController.navigationItem.hidesSearchBarWhenScrolling = false
    }
}
