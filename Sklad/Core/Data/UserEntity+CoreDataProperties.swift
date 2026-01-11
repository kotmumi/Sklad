//
//  UserEntity+CoreDataProperties.swift
//  Sklad
//
//  Created by Кирилл Котыло on 25.09.25.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var name: String

}

extension UserEntity : Identifiable {

}
