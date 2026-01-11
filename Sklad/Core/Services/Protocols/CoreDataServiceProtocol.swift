//
//  CoreDataServiceProtocol.swift
//  Sklad
//
//  Created by Кирилл Котыло on 26.08.25.
//

import CoreData

protocol CoreDataServiceProtocol {
    func saveItems(_ items: [Item]) async
    func saveWriteOff(_ items: [ItemWriteOff]) async
    func saveUser(_ users: [User]) async
    func updateWriteOff(_ writeOff: ItemWriteOff) async
    func fetchAllItems() -> [ItemEntity]
    func fetchAllWriteOffItems() -> [WriteOffEntity]
    func fetchAllUsers() -> [UserEntity]
    func searchItems(query: String) -> [ItemEntity]
    func deleteAllItems() async
}
