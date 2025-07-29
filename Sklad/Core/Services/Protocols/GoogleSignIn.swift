//
//  SignIn.swift
//  Sklad
//
//  Created by Кирилл Котыло on 29.07.25.
//

// Протокол работы с OAuth Google
protocol GoogleSignIn: AnyObject {
    func getToken() async throws -> String?
    func checkUserAuth() async -> Bool
}
