//
//  NetworkError.swift
//  StockTrace
//
//  Created by Кирилл Котыло on 8.07.25.
//
import GoogleSignIn

enum NetworkError: Error, LocalizedError {
    
    case invalidURL
    case unauthorized
    case forbidden(message: String)
    case serverError(statusCode: Int, message: String)
    case decodingError(Error)
    case tokenError
    case emptyData
    case invalidRange
    
    var errorDescription: String? {
        switch self {
        case .forbidden(let message):
            return "Доступ запрещен: \(message)"
        case .unauthorized:
            return "Требуется авторизация в Google"
        case .invalidURL:
            return "Неверный URL запроса"
        case .serverError(_, let message):
            return "Ошибка сервера: \(message)"
        case .decodingError(let error):
            return "Ошибка обработки данных: \(error.localizedDescription)"
        case .tokenError:
            return "Ошибка токена доступа"
        case .emptyData:
            return "Сервер не вернул данные"
        case .invalidRange:
            return "Неверный диапазон ячеек"
        }
    }
}
