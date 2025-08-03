//
//  ViewController.swift
//  StockTrace
//
//  Created by Кирилл Котыло on 23.06.25.
//

import UIKit
import GoogleSignIn

class AuthViewController: UIViewController {
    
    private let authView = AuthView()
    
    override func loadView() {
        view = authView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        authView.signInButton.addTarget(self, action: #selector(googleSignIn), for: .touchUpInside)
    
    }
    
    @objc
    private func googleSignIn() {
        let scopes = ["https://www.googleapis.com/auth/spreadsheets"] // Чтение таблиц
                                  
        GIDSignIn.sharedInstance.signIn(
            withPresenting: self,
            hint: nil,
            additionalScopes: scopes
        ) { result, error in
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else { return }
            let email = user.profile?.email ?? "No email"
            print("Успешный вход пользователя: \(email)")
            let mainVC = MainTabBarController()
            self.view.window?.rootViewController = mainVC
        }
    }
}

func signOut() {
    // 1. Выход из Google Sign-In
    GIDSignIn.sharedInstance.signOut()
    
    // 2. Дополнительные действия (опционально)
    clearUserData()
    
    print("Пользователь успешно вышел из системы")
}

// MARK: - Вспомогательные методы

private func clearUserData() {
    // Очистка сохраненных данных пользователя
    UserDefaults.standard.removeObject(forKey: "userCredentials")
   // KeychainHelper.deleteAccessToken()
}

