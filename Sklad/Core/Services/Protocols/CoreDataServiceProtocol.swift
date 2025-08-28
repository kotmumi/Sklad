//
//  CoreDataServiceProtocol.swift
//  Sklad
//
//  Created by Кирилл Котыло on 26.08.25.
//

import CoreData

protocol CoreDataServiceProtocol {
    func saveItems(_ items: [Item]) async
    func fetchAllItems() -> [ItemEntity]
    func searchItems(query: String) -> [ItemEntity]
    func deleteAllItems() async
}
