
// Core/Data/CoreDataManager.swift
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()

    let container: NSPersistentContainer

    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }

    private init() {
        container = NSPersistentContainer(name: "SkladModel")

        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        // 3. (ОПЦИОНАЛЬНО) Автоматически сливаем изменения из viewContext в store
        viewContext.automaticallyMergesChangesFromParent = true
    }

    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func newBackgroundContext() -> NSManagedObjectContext {
        return container.newBackgroundContext()
    }
    
    func printAllItems() {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        
        do {
            let items = try context.fetch(fetchRequest)
            print("\n=== CoreData Items ===")
            print("Total items: \(items.count)")
            
            for (index, item) in items.enumerated() {
                print("\(index + 1). \(item.commercialName)")
                print("   Section: \(item.section ?? "No section")")
                print("   Number: \(item.number ?? "No number")")
                print("   Quantity: \(item.quantity)")
                print("---")
            }
            
        } catch {
            print("Failed to fetch items: \(error)")
        }
    }
}
