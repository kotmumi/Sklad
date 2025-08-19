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
    weak var coordinator: AuthCoordinator?
    
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
        let scopes = ["https://www.googleapis.com/auth/spreadsheets"]
                                  
        GIDSignIn.sharedInstance.signIn(
            withPresenting: self,
            hint: nil,
            additionalScopes: scopes
        ) { [weak self] result, error in
            guard let self else { return }
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else { return }
            let email = user.profile?.email ?? "No email"
            print("Успешный вход пользователя: \(email)")
            self.coordinator?.handleAuthSuccess(token: user.accessToken.tokenString)
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

