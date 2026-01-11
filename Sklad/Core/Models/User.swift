//
//  User.swift
//  Sklad
//
//  Created by Кирилл Котыло on 24.09.25.
//
import Foundation

struct User {
    let name: String
    
    init(from user: UserEntity) {
        self.name = user.name
    }
    
    init(name: String) {
        self.name = name
    }
}

