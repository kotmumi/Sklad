//
//  WriteOffEntity+CoreDataProperties.swift
//  Sklad
//
//  Created by Кирилл Котыло on 26.08.25.
//
//

import Foundation
import CoreData


extension WriteOffEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WriteOffEntity> {
        return NSFetchRequest<WriteOffEntity>(entityName: "WriteOffEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var itemName: String?
    @NSManaged public var quantity: Double
    @NSManaged public var unit: String?
    @NSManaged public var author: String?
    @NSManaged public var project: String?
    @NSManaged public var status: String?
    @NSManaged public var date: Date?
    @NSManaged public var isSynced: Bool

}

extension WriteOffEntity : Identifiable {

}
