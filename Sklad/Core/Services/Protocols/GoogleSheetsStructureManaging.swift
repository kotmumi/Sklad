//
//  GoogleSheetsStructureManaging.swift
//  Sklad
//
//  Created by Кирилл Котыло on 29.07.25.
//

// Протокол для удаления и получения ID таблицы Google Sheets

protocol GoogleSheetsStructureManaging {
    
    // Асинхронное удаление данных
    // - Parameters:
    // - spreadsheetId: Идентификатор таблицы(Пример: 1PUZLv4J3XC9CGTmvmia_nEP0ZW12pZmciC1PA0hFnw4)
    // - rowNumber: Номер строки для удаления
    
    func deleteRow(sheetId: Int, rowNumber: Int) async throws
    
    //Получение ID таблицы типа Int
    func fetchSheetId() async throws -> Int
}
