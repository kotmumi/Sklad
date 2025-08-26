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
