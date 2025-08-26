//
//  MainViewModel.swift
//  Sklad
//
//  Created by Кирилл Котыло on 26.08.25.
//

import Combine
import Foundation

final class MainViewModel {
    // MARK: Output
    @Published var items: [Item] = []
    @Published var isLoading: Bool = false
    @Published var errorMassage: String?
    
    // MARK: Dependencies
    private let googleSheetManager: GoogleSheetsDataFetching
    private let coordinator: MainCoordinator
    
    // MARK: Pagination
    private var currentPage = 0
    private var itemsPerPage = 50
    private var hasMoreData = true
    
    init(googleSheetManager: GoogleSheetsDataFetching, coordinator: MainCoordinator) {
        self.googleSheetManager = googleSheetManager
        self.coordinator = coordinator
    }
    
    @MainActor
    func loadInitialData() async {
        guard !isLoading else { return }
        
        isLoading = true
        
        defer { isLoading = false }
        
        do {
            let response = try await googleSheetManager.fetchData(spreadsheetId: Spreadsheet.StorageSheet.id, range: Spreadsheet.StorageSheet.storageList, limit: itemsPerPage, offset: 0)
            
            currentPage = 1
            let newItems = processResponse(response)
            items.append(contentsOf: newItems)
            hasMoreData = newItems.count >= itemsPerPage
        } catch {
            errorMassage = "Ошибка загрузки \(error.localizedDescription)"
        }
    }
    
    @MainActor
    func loadNextPageIfNeeded() async {
        guard !isLoading && hasMoreData else { return }
        
        isLoading = true
        defer { isLoading = false }
        do {
            let response = try await googleSheetManager.fetchData(spreadsheetId: Spreadsheet.StorageSheet.id, range: Spreadsheet.StorageSheet.storageList, limit: itemsPerPage, offset: itemsPerPage * currentPage)
            
            currentPage += 1
            let newItems = processResponse(response)
            items.append(contentsOf: newItems)
            hasMoreData = newItems.count >= itemsPerPage
        } catch {
            errorMassage = "Ошибка загрузки \(error.localizedDescription)"
        }
    }
    
    // MARK: - Private Methods
       private func processResponse(_ response: GoogleSheetResponse) -> [Item] {
           var processedItems: [Item] = []
           
           for (index, obj) in response.values.enumerated() {
               guard obj.count > 9, index > 0 else { continue } // Пропускаем заголовок
               
               let name = obj[1]
               let actualName = obj[2]
               let unit = obj[3]
               let stringCount = obj[4].replacingOccurrences(of: ",", with: ".")
               guard let quantity = Double(stringCount.replacingOccurrences(of: "\\s", with: "", options: .regularExpression)) else {
                   continue
               }
               
               let item = Item(
                   id: UUID(),
                   details: Details(commercialName: name, technicalName: actualName, discription: obj.count > 10 ? obj[10] : nil),
                   pricing: Pricing(price: obj[5], totalPrice: obj[6]),
                   stock: StockInfo(totalQuantity: quantity, unit: unit),
                   location: Rack(section: obj[8], number: obj[9]),
                   createdAt: Date()
               )
               
               processedItems.append(item)
           }
           
           return processedItems
       }
}
