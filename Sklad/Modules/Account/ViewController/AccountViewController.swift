//
//  AccountViewController.swift
//  StockTrace
//
//  Created by Кирилл Котыло on 25.06.25.
//

import UIKit
import GoogleSignIn

class AccountViewController: UIViewController {
    private let authVC = AuthViewController()
    private let accountView = AccountView()
    weak var coordinator: AppCoordinator?
    
    override func loadView() {
        view = accountView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        accountView.signOutButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.signOut()
        }, for: .touchUpInside)
        
        GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
            DispatchQueue.main.async {
                guard let self else { return }
                if error != nil || user == nil {
                    self.accountView.config()
                } else {
                    self.accountView.config(user: user)
                }
            }
        }
    }
    
    private func signOut() {
        GIDSignIn.sharedInstance.signOut()
        coordinator?.start()
    }
}
