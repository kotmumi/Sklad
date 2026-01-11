//
//  ScanerViewModel.swift
//  Sklad
//
//  Created by Кирилл Котыло on 2.12.25.
//
import Foundation

final class ScanerViewModel {
    
    private let coreDataService: CoreDataServiceProtocol
    private var items: [Item] = []
    
    init(coreDataService: CoreDataServiceProtocol) {
        self.coreDataService = coreDataService
        self.items = self.featchAllItems()
    }
    
    func featchAllItems() -> [Item] {
        return coreDataService.fetchAllItems().map(Item.init)
    }
    
    func scaneItem(barcode: String) -> Item? {
        return items.first(where: { $0.details.commercialName == barcode })
    }
    
    func featchWriteOffItems(item: Item) -> [ItemWriteOff] {
        coreDataService.fetchAllWriteOffItems().filter { $0.itemName ==  item.details.commercialName }.map(ItemWriteOff.init)
    }
}
