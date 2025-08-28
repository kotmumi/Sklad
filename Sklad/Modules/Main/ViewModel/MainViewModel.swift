//
//  MainViewModel.swift
//  Sklad
//
//  Created by Кирилл Котыло on 26.08.25.
//

import Combine
import Foundation

final class MainViewModel {
    
    var selectedChars = Set<String>()
    var selectedNumbers = Set<String>()

    @Published var items: [Item] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let googleSheetsManager: GoogleSheetsDataFetching
    private let coreDataService: CoreDataServiceProtocol
    private let coordinator: MainCoordinator
    
    init(googleSheetsManager: GoogleSheetsDataFetching,
         coreDataService: CoreDataServiceProtocol,
         coordinator: MainCoordinator) {
        self.googleSheetsManager = googleSheetsManager
        self.coreDataService = coreDataService
        self.coordinator = coordinator
    }
    
    @MainActor
    func loadData() async {
        guard !isLoading else { return }
        isLoading = true
        
        showCachedData()
        
        do {
            let networkItems = try await fetchFromNetwork()
            await coreDataService.saveItems(networkItems)
            showCachedData()
            errorMessage = nil
        } catch {
            errorMessage = "Не удалось обновить данные. Работаем в офлайн-режиме."
        }
        isLoading = false
       // CoreDataManager.shared.printAllItems()
    }
    
    @MainActor
    func refreshData() async {
        await loadData()
    }

    func setRackFilter(selectedChars: Set<String>, selectedNumbers: Set<String>) {
        self.selectedChars = selectedChars
        self.selectedNumbers = selectedNumbers
    }
    
    func clearSearch() {
    }
    
    func getWriteOffs(for itemName: String) -> [ItemWriteOff] {
        return []
    }
    
    private func showCachedData() {
        let cachedEntities = coreDataService.fetchAllItems()
        items = cachedEntities.map { entity in
            Item(from: entity)
        }
    }
    
    private func fetchFromNetwork() async throws -> [Item] {
        
        let objects = try await googleSheetsManager.fetchData(
            spreadsheetId: Spreadsheet.StorageSheet.id,
            range: Spreadsheet.StorageSheet.storageList
        )
        return processResponse(objects)
    }
    
//    private func fetchFromNetworkPagination() async throws -> [Item] {
//        
//        let objects = try await googleSheetsManager.fetchData(
//            spreadsheetId: Spreadsheet.StorageSheet.id,
//            range: Spreadsheet.StorageSheet.storageList
//        )
//        return processResponse(objects)
//    }
    
    private func processResponse(_ response: GoogleSheetResponse) -> [Item] {
           var processedItems: [Item] = []
           
           for (index, obj) in response.values.enumerated() {
               guard obj.count > 9, index > 0 else { continue }
               
               let name = obj[1]
               let actualName = obj[2]
               let unit = obj[3]
               let stringCount = obj[4].replacingOccurrences(of: ",", with: ".")
               guard let quantity = Double(stringCount.replacingOccurrences(of: "\\s", with: "", options: .regularExpression)) else {
                   continue
               }
               
               let item = Item(
                   details: Details(commercialName: name,
                                    technicalName: actualName,
                                    discription: obj.count > 10 ? obj[10] : nil
                                   ),
                   pricing: Pricing(price: obj[5],
                                    totalPrice: obj[6]
                                   ),
                   stock: StockInfo(totalQuantity: quantity,
                                    unit: unit
                                   ),
                   location: Rack(section: obj[8],
                                  number: obj[9]
                                 )
               )
               
               processedItems.append(item)
           }
           return processedItems
       }
}
