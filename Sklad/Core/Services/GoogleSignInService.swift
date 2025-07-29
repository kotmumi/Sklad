//
//  GoogleSignIn.swift
//  Sklad
//
//  Created by Кирилл Котыло on 29.07.25.
//

import GoogleSignIn

final class GoogleSignInService: GoogleSignIn {
    
    func getToken() async throws -> String? {
            GIDSignIn.sharedInstance.currentUser?.accessToken.tokenString
    }
    
    func checkUserAuth() async -> Bool {
        await withCheckedContinuation { continuation in
            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                if error != nil || user == nil {
                    print("Пользователь не авторизирован")
                    continuation.resume(returning: false)
                } else {
                    print("Пользователь уже вошел \(user?.profile?.email ?? "")")
                    continuation.resume(returning: true)
                }
            }
        }
    }
}
