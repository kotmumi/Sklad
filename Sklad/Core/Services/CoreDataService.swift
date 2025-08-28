//
//  CoreDataService.swift
//  Sklad
//
//  Created by Кирилл Котыло on 26.08.25.
//

import CoreData

final class CoreDataService: CoreDataServiceProtocol {
    
    func saveItems(_ items: [Item]) async {
        let backgroundContext = CoreDataManager.shared.newBackgroundContext()
        
        await backgroundContext.perform {
            for item in items {
                let featchrequest: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
                featchrequest.predicate = NSPredicate(format: "commercialName == %@", item.details.commercialName)
                
                let itemEntity: ItemEntity
                if let existingItemEntity = try? backgroundContext.fetch(featchrequest).first {
                    itemEntity = existingItemEntity
                } else {
                    itemEntity = ItemEntity(context: backgroundContext)
                }
                
                itemEntity.commercialName = item.details.commercialName
                itemEntity.technicalName = item.details.technicalName
                itemEntity.quantity = item.stock.totalQuantity
                itemEntity.unit = item.stock.unit
                itemEntity.price = item.pricing.price
                itemEntity.totalPrice = item.pricing.totalPrice
                itemEntity.section = item.location.section
                itemEntity.number = item.location.number
                itemEntity.lastUpdated = Date()
                itemEntity.discription = item.details.discription ?? ""
            }
            do {
                try backgroundContext.save()
            } catch {
                print("Ошибка сохранения в CoreData: \(error)")
            }
        }
    }
    
    func fetchAllItems() -> [ItemEntity] {
        
        let context = CoreDataManager.shared.viewContext
        
        let featchRequest: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        
        featchRequest.sortDescriptors = [NSSortDescriptor(key: "commercialName", ascending: true)]

        do {
            return try context.fetch(featchRequest)
        } catch {
            print("Ошибка загрузки из CoreData: \(error)")
            return []
        }
    }
    
    func searchItems(query: String) -> [ItemEntity] {
        
        let context = CoreDataManager.shared.viewContext
        let fetchRequest: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(
            format: "commercialName CONTAINS[cd] %@",
            query
        )
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "commercialName", ascending: true)]
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Ошибка поиска: \(error)")
            return []
        }
    }
    
    func deleteAllItems() async {
        
        let backgroundContext = CoreDataManager.shared.newBackgroundContext()
        
        await backgroundContext.perform {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ItemEntity.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try backgroundContext.execute(deleteRequest)
                try backgroundContext.save()
            } catch {
                print("Ошибка удаления: \(error)")
            }
        }
    }
}
