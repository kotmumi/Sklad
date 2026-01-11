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
            // 1. Получаем все существующие сущности
            let fetchRequest: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
            guard let existingEntities = try? backgroundContext.fetch(fetchRequest) else { return }
            
            // 2. Создаем Set имен из сети
            let newNames = Set(items.map { $0.details.commercialName })
            
            for entity in existingEntities {
                if !newNames.contains(entity.commercialName) {
                    backgroundContext.delete(entity)
                }
            }
            
            // 4. Обновляем/добавляем актуальные элементы
            for item in items {
                let fetchRequest: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "commercialName == %@", item.details.commercialName)
                
                let itemEntity: ItemEntity
                if let existing = try? backgroundContext.fetch(fetchRequest).first {
                    itemEntity = existing
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
    
    func updateWriteOff(_ item: ItemWriteOff) async {
        let backgroundContext = CoreDataManager.shared.newBackgroundContext()
        
        await backgroundContext.perform {
            let fetchRequest: NSFetchRequest<WriteOffEntity> = WriteOffEntity.fetchRequest()
            guard let existingEntities = try? backgroundContext.fetch(fetchRequest) else { return }
            
            let newIds = Int64(item.id)
            
            let fetchRequestItem: NSFetchRequest<WriteOffEntity> = WriteOffEntity.fetchRequest()
            fetchRequestItem.predicate = NSPredicate(format: "id == %d", item.id)
            
            let writeOffEntity: WriteOffEntity
            if let existing = try? backgroundContext.fetch(fetchRequestItem).first {
                writeOffEntity = existing
            } else {
                writeOffEntity = WriteOffEntity(context: backgroundContext)
            }
            
            writeOffEntity.itemName = item.name
            writeOffEntity.id = Int64(item.id)
            writeOffEntity.author = item.author
            writeOffEntity.unit = item.unit
            writeOffEntity.status = item.status
            writeOffEntity.quantity = item.quantity
            writeOffEntity.project = item.project
            writeOffEntity.comment = item.comment
            writeOffEntity.date = item.date
        }
        
        do {
            try backgroundContext.save()
        } catch {
            print("Ошибка сохранения в CoreData: \(error)")
        }
    }
    
    
    func saveWriteOff(_ items: [ItemWriteOff]) async {
        let backgroundContext = CoreDataManager.shared.newBackgroundContext()
        
        await backgroundContext.perform {
            let fetchRequest: NSFetchRequest<WriteOffEntity> = WriteOffEntity.fetchRequest()
            guard let existingEntities = try? backgroundContext.fetch(fetchRequest) else { return }
            
            let newIds = Set(items.map { Int64($0.id) })
            
            // Удаляем записи, которых нет в новых данных
            for entity in existingEntities {
                if !newIds.contains(entity.id) {
                    backgroundContext.delete(entity)
                }
            }
            
            for item in items {
                let fetchRequest: NSFetchRequest<WriteOffEntity> = WriteOffEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %d", item.id)
                
                let writeOffEntity: WriteOffEntity
                if let existing = try? backgroundContext.fetch(fetchRequest).first {
                    writeOffEntity = existing
                } else {
                    writeOffEntity = WriteOffEntity(context: backgroundContext)
                }
                
                writeOffEntity.itemName = item.name
                writeOffEntity.id = Int64(item.id)
                writeOffEntity.author = item.author
                writeOffEntity.unit = item.unit
                writeOffEntity.status = item.status
               // print("\(item.name) - \(item.status) - \(item.quantity)")
                writeOffEntity.quantity = item.quantity
                writeOffEntity.project = item.project
                writeOffEntity.comment = item.comment
                writeOffEntity.date = item.date
            }
            
            do {
                try backgroundContext.save()
            } catch {
                print("Ошибка сохранения в CoreData: \(error)")
            }
        }
    }

    
    func saveUser(_ users: [User]) async {
        let backgroundContext = CoreDataManager.shared.newBackgroundContext()
        
        await backgroundContext.perform {
            // 1. Загружаем все текущие записи
            let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
            guard let existingEntities = try? backgroundContext.fetch(fetchRequest) else { return }
            
            // 2. Формируем Set имён из сети
            let newNames = Set(users.map { $0.name })
            
            // 3. Удаляем тех, кого нет в новых данных
            for entity in existingEntities {
                if !newNames.contains(entity.name) {
                    backgroundContext.delete(entity)
                }
            }
            
            // 4. Добавляем/обновляем пользователей
            for user in users {
                let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "name == %@", user.name)
                
                let userEntity: UserEntity
                if let existing = try? backgroundContext.fetch(fetchRequest).first {
                    userEntity = existing
                } else {
                    userEntity = UserEntity(context: backgroundContext)
                }
                
                userEntity.name = user.name
            }
            
            // 5. Сохраняем изменения
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
    
    func fetchAllWriteOffItems() -> [WriteOffEntity] {
        
        let context = CoreDataManager.shared.viewContext
        
        let featchRequest: NSFetchRequest<WriteOffEntity> = WriteOffEntity.fetchRequest()
        
        featchRequest.sortDescriptors = [NSSortDescriptor(key: "itemName", ascending: true)]

        do {
            return try context.fetch(featchRequest)
        } catch {
            print("Ошибка загрузки из CoreData: \(error)")
            return []
        }
    }
    
    func fetchAllUsers() -> [UserEntity] {
        
        let context = CoreDataManager.shared.viewContext
        
        let featchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        
        featchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

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
