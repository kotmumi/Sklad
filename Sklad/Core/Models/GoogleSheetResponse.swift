//
//  GoogleSheetResponse.swift
//  Sklad
//
//  Created by Кирилл Котыло on 29.07.25.
//

struct GoogleSheetResponse: Decodable {
    let range: String
    let majorDimension: String
    let values: [[String]]
}
