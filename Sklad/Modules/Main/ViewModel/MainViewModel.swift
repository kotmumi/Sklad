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
    @Published var itemsWriteOff: [ItemWriteOff] = []
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
            let networkWriteOffItems = try await fetchWriteOffFromNetwork()
            await coreDataService.saveItems(networkItems)
            await coreDataService.saveWriteOff(networkWriteOffItems)
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
        itemsWriteOff.filter { $0.name == itemName }
    }
    
    private func showCachedData() {
        
        let cachedEntities = coreDataService.fetchAllItems()
        items = cachedEntities.map { entity in
            Item(from: entity)
        }
        
        let cachedWriteOffEntities = coreDataService.fetchAllWriteOffItems()
        itemsWriteOff = cachedWriteOffEntities.map { entity in
            ItemWriteOff(from: entity)
        }
        print(itemsWriteOff)
        
    }
    
    private func fetchFromNetwork() async throws -> [Item] {
        
        let objects = try await googleSheetsManager.fetchData(
            spreadsheetId: Spreadsheet.StorageSheet.id,
            range: Spreadsheet.StorageSheet.storageList
        )
        return processResponse(objects)
    }
    
    private func fetchWriteOffFromNetwork() async throws -> [ItemWriteOff] {
        
        let objects = try await googleSheetsManager.fetchData(
            spreadsheetId: Spreadsheet.WriteOffSheet.id,
            range: Spreadsheet.WriteOffSheet.writeOffList()
        )
        return processResponseWriteOff(objects)
    }
    
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
    
    private func processResponseWriteOff(_ response: GoogleSheetResponse) -> [ItemWriteOff] {
        var processedItemWriteOffs: [ItemWriteOff] = []
        
        for (index, obj) in response.values.enumerated() {
            guard index >= 2, obj.count > 5 else { continue }
            
            let name = obj[0]
            let unit = obj[1]
            let stringCount = obj[2]
                .replacingOccurrences(of: ",", with: ".")
                .replacingOccurrences(of: " ", with: "")
            guard let quantity = Double(stringCount) else {
                print("Ошибка: неверный формат количества в строке \(index)")
                continue
            }
            
            let author = obj[3]
            let project = obj[4]
            let status = obj[5]
            
            let itemWriteOff = ItemWriteOff(
                id: index,
                name: name,
                quantity: quantity,
                unit: unit,
                author: author,
                project: project,
                status: status,
                comment: nil,
                date: nil
            )
            
            processedItemWriteOffs.append(itemWriteOff)
            
            // Обновление основного массива items
            if let index = items.firstIndex(where: {
                $0.details.commercialName == name ||
                $0.details.commercialName.dropFirst(3) == name
            }) {
                if status == "Взял на тесты" {
                    items[index].stock.testedQuantity += quantity
                } else {
                    items[index].stock.allocatedQuantity += quantity
                }
            }
        }
        
        return processedItemWriteOffs
    }
}
