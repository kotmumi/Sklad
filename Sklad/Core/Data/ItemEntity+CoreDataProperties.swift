//
//  ItemEntity+CoreDataProperties.swift
//  Sklad
//
//  Created by Кирилл Котыло on 27.08.25.
//
//

import Foundation
import CoreData


extension ItemEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemEntity> {
        return NSFetchRequest<ItemEntity>(entityName: "ItemEntity")
    }

    @NSManaged public var commercialName: String
    @NSManaged public var technicalName: String?
    @NSManaged public var quantity: Double
    @NSManaged public var unit: String
    @NSManaged public var price: String?
    @NSManaged public var totalPrice: String?
    @NSManaged public var section: String?
    @NSManaged public var number: String?
    @NSManaged public var lastUpdated: Date?
    @NSManaged public var discription: String?

}

extension ItemEntity : Identifiable {

}
