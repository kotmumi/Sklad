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
    var users: [User] = []

    @Published var items: [Item] = []
    @Published var itemsWriteOff: [ItemWriteOff] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    var reloade = PassthroughSubject<Void, Never>()
    
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
            async let itemsTask = fetchFromNetwork()
            async let writeOffTask = fetchWriteOffFromNetwork()
            async let usersTask = fetchUsers()

            let (networkItems, networkWriteOffItems, networkUser) = await (
                try itemsTask, try writeOffTask, try usersTask
            )
            
            await coreDataService.saveItems(networkItems)
            await coreDataService.saveWriteOff(networkWriteOffItems)
            await coreDataService.saveUser(networkUser)
            showCachedData()
            errorMessage = nil
        } catch {
            errorMessage = "Не удалось обновить данные. Работаем в офлайн-режиме."
        }
        reloade.send()
        isLoading = false
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
    
    private func fetchUsers() async throws -> [User] {
        let objects = try await googleSheetsManager.fetchData(spreadsheetId: Spreadsheet.WriteOffSheet.id, range: Spreadsheet.WriteOffSheet.userList)
        return processResponseUsers(objects)
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
            guard index >= 1, obj.count > 5 else { continue }
            
            let name = obj[0]
            let unit = obj[1]
            let stringCount = obj[2]
                .replacingOccurrences(of: ",", with: ".")
                .replacingOccurrences(of: " ", with: "")
            guard let quantity = Double(stringCount) else {
                //print("Ошибка: неверный формат количества в строке \(index)")
                continue
            }
            
            let author = obj[3]
            let project = obj[4]
            let status = obj[5]
            var comment: String
            var dateString: String
            if obj.count > 6 {
                comment = obj[6]
            } else {
               // print("\(name) Комментарий отсутствует")
                comment = ""
            }
            
            if obj.count > 7 {
                dateString = obj[7]
            } else {
               // print("\(name) Время отсутствует")
                dateString = ""
            }
            
            let itemWriteOff = ItemWriteOff(
                id: index,
                name: name,
                quantity: quantity,
                unit: unit,
                author: author,
                project: project,
                status: status,
                comment: comment,
                date: dateString
            )
            
            processedItemWriteOffs.append(itemWriteOff)
           
            // Обновление основного массива items
            if let index = items.firstIndex(where: {
                $0.details.commercialName == name ||
                $0.details.commercialName.dropFirst(3) == name
            }) {
                if status == "Переместить на Телипко М.Г." {
                    items[index].stock.testedQuantity += quantity
                   // print("\(items[index].details.commercialName) \(status)")
                } else {
                    items[index].stock.allocatedQuantity += quantity
                }
              //  print("\(items[index].details.commercialName) allocated = \(items[index].stock.allocatedQuantity) test = \(items[index].stock.testedQuantity)")
            }
            
            
        }
       // print("writeOff count = \(processedItemWriteOffs.count)")
        return processedItemWriteOffs
    }
    
    private func processResponseUsers(_ response: GoogleSheetResponse) -> [User] {
        var users: [User] = []
        
        for (index, obj) in response.values.enumerated() {
            guard obj.count > 1, index > 0 else { continue }
            
            let name = obj[1]
            users.append(User(name: name))
        }
        return users
    }
}
