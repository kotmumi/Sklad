//
//  ItemWriteOff.swift
//  Sklad
//
//  Created by Кирилл Котыло on 19.08.25.
//

struct ItemWriteOff {
    var id: Int
    var name: String
    var quantity: Double
    var unit: String
    var author: String
    var project: String
    var status: String
    var comment: String?
    var date: String?
    
    init(from item: WriteOffEntity) {
        self.id = Int(item.id)
        self.name = item.itemName ?? ""
        self.quantity = item.quantity
        self.unit = item.unit ?? ""
        self.author = item.author ?? ""
        self.project = item.project ?? ""
        self.status = item.status ?? ""
        self.comment = item.comment
        self.date = item.date ?? ""
    }
    
    init(id: Int, name : String, quantity: Double, unit: String, author: String, project: String, status: String, comment: String?, date: String?) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.unit = unit
        self.author = author
        self.project = project
        self.status = status
        self.comment = comment
        self.date = date
    }
}
