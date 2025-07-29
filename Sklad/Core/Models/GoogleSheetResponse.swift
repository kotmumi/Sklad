//
//  GoogleSheetResponse.swift
//  StockTrace
//
//  Created by Кирилл Котыло on 8.07.25.
//

struct GoogleSheetResponse: Decodable {
    let range: String
    let majorDimension: String
    let values: [[String]]
}
