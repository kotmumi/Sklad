//
//  GoogleSheetsDataWriting.swift
//  Sklad
//
//  Created by Кирилл Котыло on 29.07.25.
//
// Протокол для записи данных в Google Sheets
protocol GoogleSheetsDataWriting {
    
    // Асинхронное запись данных
    // - Parameters:
    // - spreadsheetId: Идентификатор таблицы
    // - range: Диапазон данных (например "Лист1!A1:D5")
    // - values: Значение для записи
    
    
    func writeValues(spreadsheetId: String, range: String, values: [[String]]) async throws
    func writeValues(spreadsheetId: String, range: String, values: [[String]], completion: @escaping (Result<Void, NetworkError>) -> Void)
}
