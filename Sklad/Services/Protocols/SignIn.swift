//
//  SignIn.swift
//  Sklad
//
//  Created by Кирилл Котыло on 29.07.25.
//

protocol SignIn: AnyObject {
    func checkUserAuth() async -> Bool
}
