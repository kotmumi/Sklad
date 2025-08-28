//
//  Spreadsheet.swift
//  StockTrace
//
//  Created by Кирилл Котыло on 8.07.25.
//

import Foundation

struct Spreadsheet {
    
    private static let russianFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "LLLL yyyy"
        return formatter
    }()
    
    static func getCurrentMonthYear() -> String {
        return russianFormatter.string(from: Date()).capitalized
    }
    
    struct StorageSheet {
        static let id = "1YDfMuU23ZiDN8HegT4OgMkWXp--Vv9o2QwXNqPDTHik"//Test "1-mA5I8e-knb5VKjAc3OQU11zSa9WUw0pNF16qpVmTHI"
        static let storageList = "'Остатки технопарка'"
        static let projectList = "'Список Объектов'"
    }
    
    struct WriteOffSheet {
        static let id = "1PUZLv4J3XC9CGTmvmia_nEP0ZW12pZmciC1PA0hFnw4"
        static let writeOffList = {
            "'Списание \(getCurrentMonthYear())'"
        }
        static let writeOffListName = {
            "Списание \(getCurrentMonthYear())"
        }
    }
}
