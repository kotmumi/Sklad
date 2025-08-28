//
//  Item.swift
//  Sklad
//
//  Created by Кирилл Котыло on 29.07.25.
//

import Foundation

struct Item: Identifiable {
    let id: UUID
    var details: Details
    var pricing: Pricing
    var stock: StockInfo
    var location: Rack
    let createdAt: Date
    
    init(from item: ItemEntity) {
        self.id = UUID()
        self.details = .init(commercialName: item.commercialName, technicalName: item.technicalName, discription: item.discription)
        self.pricing = .init(price: item.price ?? "", totalPrice: item.totalPrice ?? "")
        self.stock = .init(totalQuantity: item.quantity, unit: item.unit)
        self.location = .init(section: item.section ?? "", number: item.number ?? "")
        self.createdAt = Date()
    }
    init(details: Details, pricing: Pricing, stock: StockInfo, location: Rack) {
        self.id = UUID()
        self.details = details
        self.pricing = pricing
        self.stock = stock
        self.location = location
        self.createdAt = Date()
    }
}


struct Details {
    var commercialName: String
    var technicalName: String?
    var discription: String?
}

struct Pricing {
    var price: String
    var totalPrice: String
}

struct StockInfo {
    var totalQuantity: Double
    var allocatedQuantity: Double = 0.0
    var testedQuantity: Double = 0.0
    var unit: String
    
    var availableQuantity: Double {
        totalQuantity - allocatedQuantity - testedQuantity
    }
}

struct Rack {
    let section: String
    let number: String
    
    var full: String {
        "\(section)\(number)"
    }
}
struct Metadata {
    let createdAt: Date
    var lastModified: Date
}
