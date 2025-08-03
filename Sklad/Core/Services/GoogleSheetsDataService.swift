//
//  GoogleSheetsDataService.swift
//  Sklad
//
//  Created by Кирилл Котыло on 29.07.25.
//

import Foundation

final class GoogleSheetsDataService: GoogleSheetsService {
    private let googleSignInService: GoogleSignInService = GoogleSignInService()
    
    
    func fetchData(spreadsheetId: String, range: String) async throws -> GoogleSheetResponse {
        try await withCheckedThrowingContinuation { continuation in
            fetchData(spreadsheetId: spreadsheetId, range: range) { result in
                switch result{
                case .success(let objs):
                    continuation.resume(returning: objs)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    private func verifyTokenScopes(token: String) {
        let url = URL(string: "https://www.googleapis.com/oauth2/v1/tokeninfo?access_token=\(token)")!
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let scopes = json["scope"] as? String {
                print("Токен имеет scope: \(scopes)")
            }
        }.resume()
    }
    
    func fetchData(spreadsheetId: String, range: String, completion: @escaping (Result<GoogleSheetResponse, NetworkError>) -> Void) {
        guard let token = googleSignInService.getToken() else {
            completion(.failure(.tokenError))
            return
        }
        verifyTokenScopes(token: token)
        
        let urlString = "https://sheets.googleapis.com/v4/spreadsheets/\(spreadsheetId)/values/\(range)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
       
        // 4. Настройка запроса
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 30
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // 5. Выполнение запроса
        URLSession.shared.dataTask(with: request) { data, response, error in
            // 6. Обработка ошибок сети
            if let error = error {
                completion(.failure(.serverError(statusCode: 0, message: error.localizedDescription)))
                return
            }
            // 7. Проверка HTTP-ответа
            guard let httpResponse = response as? HTTPURLResponse else {
                print("🔴 Invalid response: \(response.debugDescription)")
                completion(.failure(.serverError(statusCode: 0, message: error?.localizedDescription ?? "")))
                return
            }
            
            print("🔵 Status code: \(httpResponse.statusCode)")
                       print("🔵 Headers: \(httpResponse.allHeaderFields)")
            // 8. Проверка статус-кода
            guard (200..<300).contains(httpResponse.statusCode) else {
                print("🔴 API error: \(httpResponse.statusCode)")
                let message = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                completion(.failure(.serverError(statusCode: httpResponse.statusCode, message: message)))
                return
            }
            // 9. Проверка данных
            guard let data = data else {
                completion(.failure(.emptyData))
                return
            }
            // 10. Парсинг ответа
            do {
                let objects = try JSONDecoder().decode(GoogleSheetResponse.self, from: data)
                completion(.success(objects))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
    
    func writeValues(spreadsheetId: String, range: String, values: [[String]]) async throws {
        try await withCheckedThrowingContinuation { continuation in
            writeValues(spreadsheetId: spreadsheetId, range: range, values: values) { result in
                switch result{
                case .success(let objs):
                    continuation.resume(returning: objs)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func writeValues(spreadsheetId: String, range: String, values: [[String]], completion: @escaping (Result<Void, NetworkError>) -> Void) {
        
        guard let token = googleSignInService.getToken() else {
            completion(.failure(.tokenError))
            return
        }
        
        let urlString = "https://sheets.googleapis.com/v4/spreadsheets/\(spreadsheetId)/values/\(range):append?valueInputOption=USER_ENTERED"
        
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "values": values,
            "majorDimension": "ROWS"
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            // 1. Проверка на ошибку сети
            if let error = error {
                completion(.failure(.forbidden(message: "Network error: \(error.localizedDescription)")))
                //print("Network error: \(error.localizedDescription)")
                completion(.failure(.forbidden(message: "Network error: \(error.localizedDescription)")))
                return
            }
            // 2. Проверка HTTP статус-кода
            guard let httpResponse = response as? HTTPURLResponse else {
                //print("Invalid response")
                completion(.failure(.forbidden(message: "Invalid response")))
                return
            }
            
            print("Status code: \(httpResponse.statusCode)")
            
            // 3. Проверка успешного статус-кода (200-299)
            guard (200...299).contains(httpResponse.statusCode) else {
                //print("Server error: \(httpResponse.statusCode)")
                //if let data = data {
                   // let responseString = String(data: data, encoding: .utf8) ?? ""
                    //print("Response body: \(responseString)")
               // }
                completion(.failure(.forbidden(message: "Server error: \(httpResponse.statusCode)")))
                return
            }
            // 4. Проверка наличия данных
            guard let data = data else {
                //print("No data received")
                completion(.failure(.forbidden(message: "No data received")))
                return
            }
            // 5. Парсинг JSON ответа
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                print("Success response: \(json ?? [:])")
                
                // Пример обработки успешного ответа
                if let updates = json?["updates"] as? [String: Any],
                   let updatedRows = updates["updatedRows"] as? Int {
                    print("Updated rows: \(updatedRows)")
                    completion(.success(()))
                }
            } catch {
                print("JSON parsing error: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func deleteRow(sheetId: Int, rowNumber: Int) async throws {
        
        guard let token = googleSignInService.getToken() else {
            throw NetworkError.tokenError
        }

        let urlString = "https://sheets.googleapis.com/v4/spreadsheets/\(Spreadsheet.WriteOffSheet.id):batchUpdate"
        
        guard let url = URL(string: urlString) else { throw NetworkError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: Any] = [
            "requests": [
                [
                    "deleteDimension": [
                        "range": [
                            "sheetId": sheetId,
                            "dimension": "ROWS",
                            "startIndex": rowNumber, // Нумерация с 0
                            "endIndex": rowNumber + 1 // Удаляем одну строку
                        ]
                    ]
                ]
            ]
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            throw NetworkError.emptyData
        }
        let (data, response) = try await URLSession.shared.data(for: request)
           
           guard let httpResponse = response as? HTTPURLResponse else {
               throw NSError(domain: "NetworkError", code: -3, userInfo: [
                   NSLocalizedDescriptionKey: "Invalid response type"
               ])
           }
           
           guard (200...299).contains(httpResponse.statusCode) else {
               let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
               throw NSError(domain: "APIError", code: httpResponse.statusCode, userInfo: [
                   NSLocalizedDescriptionKey: "Server returned error: \(errorMessage)"
               ])
           }
        print("sucsses")
    }
    
    func fetchSheetId() async throws -> Int {
        guard let token = googleSignInService.getToken() else {
            throw NetworkError.tokenError
        }
        
        let urlString = "https://sheets.googleapis.com/v4/spreadsheets/\(Spreadsheet.WriteOffSheet.id)?fields=sheets(properties(sheetId,title))"
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
          }
        
        var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.serverError(statusCode: -1, message: "status code: ...")
            }
        
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            guard let sheets = json?["sheets"] as? [[String: Any]] else {
                throw NetworkError.emptyData
            }
            
            for sheet in sheets {
                if let properties = sheet["properties"] as? [String: Any],
                   let title = properties["title"] as? String,
                   let sheetId = properties["sheetId"] as? Int,
                   title == Spreadsheet.WriteOffSheet.writeOffListName() {
                    return sheetId
                }
            }
        throw NetworkError.emptyData
    }
}
