//
//  GoogleSheetsDataFetching.swift
//  Sklad
//
//  Created by Кирилл Котыло on 29.07.25.
//

    // Протокол для чтения данных из Google Sheets
protocol GoogleSheetsDataFetching {
    
    // Асинхронное получение данных
    // - Parameters:
    // - spreadsheetId: Идентификатор таблицы
    // - range: Диапазон данных (например "Лист1!A1:D5")
    // - Returns: Модель с данными
    
    func fetchData(spreadsheetId: String, range: String) async throws -> GoogleSheetResponse
    
    // Получение данных с callback
    func fetchData(spreadsheetId: String, range: String, completion: @escaping (Result<GoogleSheetResponse, NetworkError>) -> Void)
    
    //Получение данных с пагинацией
    func fetchData(spreadsheetId: String, range: String, limit: Int, offset: Int) async throws -> GoogleSheetResponse
}
