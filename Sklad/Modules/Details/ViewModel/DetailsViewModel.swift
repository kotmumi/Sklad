//
//  DetailsViewModel.swift
//  Sklad
//
//  Created by Кирилл Котыло on 22.09.25.
//

import Combine
import Foundation
import UIKit

enum StatusItem: String {
    
    case inStock
    case writeOff = "На списание"
    case inTest = "Переместить на Телипко М.Г."
    
    var color: UIColor {
        switch self {
        case .inStock: return .stock
        case .writeOff: return .writeOff
        case .inTest: return .test
        }
    }
    
    var segmentIndex: Int {
        switch self {
        case .inStock: return 0
        case .writeOff: return 1
        case .inTest: return 2
        
        }
    }
    
    static func from(segmentIndex: Int) -> StatusItem {
        switch segmentIndex {
        case 0: return .inStock
        case 1: return .writeOff
        case 2: return .inTest
        default : return .inStock
        }
    }
}

struct DetailsViewState {
    let selectedStatus: StatusItem
    let isWriteOffButtonHidden: Bool
    let tableData: TableData
    
    struct TableData {
        let numberOfRows: Int
        let cellType: CellType
        
        enum CellType {
            case header(Item)
            case info(Item,[ItemWriteOff])
            case writeOff(ItemWriteOff, Bool)
        }
    }
}

final class DetailsViewModel {
    
    let viewDidLoad = PassthroughSubject<Void, Never>()
    let segmentChanged = PassthroughSubject<Int, Never>()
    let segmentWriteOffChanged = PassthroughSubject<Int, Never>()
    let writeOffButtonapped = PassthroughSubject<Void, Never>()
    
    @Published private(set) var viewState: DetailsViewState?
    @Published private(set) var navigationTitle: String? = "Остатки"
    let navigateToWriteOff = PassthroughSubject<Void, Never>()
    var countItem = CurrentValueSubject<Double, Never>(0.0)
    var descriptionItem = CurrentValueSubject<String, Never>("")
    var isSelectUser = CurrentValueSubject<Bool,Never>(false)
    var selectUser = CurrentValueSubject<Bool,Never>(false)
    var project = CurrentValueSubject<Project?,Never>(nil)
    var isButtonEnable = CurrentValueSubject<Bool,Never>(false)
    var isLoading = PassthroughSubject<Void, Never>()
    var searchText = CurrentValueSubject<String, Never>("")
    var projectInFilters = CurrentValueSubject<[Project], Never> ([])
    var relode = PassthroughSubject<Void, Never>()
    
    var item: Item
    var projects = [Project]()
    var users: [User] = []
    var usersInTable: [User] = []
    var user: User?
    private var allWriteOffs: [ItemWriteOff]
    private var test: [ItemWriteOff] { allWriteOffs.filter {$0.status == "Переместить на Телипко М.Г."}}
    private var writeOffs: [ItemWriteOff] { allWriteOffs.filter {$0.status == "На списание"}}
    
    private var currentStatus: StatusItem = .inStock
    private var currentWriteOffStatus: StatusItem = .inTest
    private var cancellables = Set<AnyCancellable>()
    
    private let googleSheetsManager: GoogleSheetsService
    private let coreDataService: CoreDataServiceProtocol
    

    init(item: Item, writeOff: [ItemWriteOff], googleSheetsManager:GoogleSheetsService, coreDataService: CoreDataServiceProtocol) {
        self.item = item
        self.allWriteOffs = writeOff
        self.googleSheetsManager = googleSheetsManager
        self.coreDataService = coreDataService
        processActualCountItem(item: &self.item, writeOffItems: writeOff)
        countItem.send(item.stock.availableQuantity)
        bind()
    }
    
    private func bind() {
        viewDidLoad
            .map { [weak self] _ in
                self?.createInitialViewState()
            }
            .sink { [weak self] viewState in
                if let viewState = viewState {
                    self?.viewState = viewState
                    self?.showCachedData()
                }
            }
            .store(in: &cancellables)
        
        searchText
            .sink { [weak self] search in
                guard let self else {return}
                let filteredProjects: [Project]
                
                if search.isEmpty {
                    filteredProjects = self.projects
                } else {
                    filteredProjects = projects.filter { $0.name.contains(search) || String($0.systemNumber ?? -1).contains(search) }
                }
                projectInFilters.send(filteredProjects)
            }
            .store(in: &cancellables)
            
        
        segmentChanged
            .map {
                StatusItem.from(segmentIndex: $0)
            }
            .sink { [weak self] newStatus in
                self?.currentStatus = newStatus
                self?.updateViewState()
            }
            .store(in: &cancellables)
        
        segmentWriteOffChanged
            .map {
                StatusItem.from(segmentIndex: $0)
            }
            .sink { [weak self] newStatus in
                self?.currentWriteOffStatus = newStatus
            }
            .store(in: &cancellables)
        
        writeOffButtonapped
            .sink { [weak self] in
                self?.navigateToWriteOff.send()
            }
            .store(in: &cancellables)
        
        isSelectUser
            .sink { [weak self] isSelected in
                guard let self else { return }
                if isSelected {
                    self.usersInTable = self.users
                } else {
                    self.usersInTable = self.users.filter {$0.name == self.user?.name }
                }
                if user != nil {
                    self.selectUser.send(true)
                } else {
                    self.selectUser.send(false)
                }
            }
            .store(in: &cancellables)
        
        isButtonEnable
            .combineLatest(selectUser, project, countItem)
            .map { [weak self] _, isSelect, project, count in
                guard let self = self else { return false }
                
                let isUserSelected = isSelect
                let isProjectSelected = project != nil
                let isCountValid = count > 0 && count <= self.item.stock.availableQuantity
                
                return isUserSelected && isProjectSelected && isCountValid
            }
            .sink { [weak self] isEnabled in
                self?.isButtonEnable.send(isEnabled)
            }
            .store(in: &cancellables)
        
    }
    
    private func createInitialViewState() -> DetailsViewState {
        DetailsViewState(
            selectedStatus: currentStatus,
            isWriteOffButtonHidden: currentStatus != .inStock,
            tableData: createTableData(for: currentStatus)
        )
    }
    
    private func updateViewState() {
            viewState = DetailsViewState(
                selectedStatus: currentStatus,
                isWriteOffButtonHidden: currentStatus != .inStock,
                tableData: createTableData(for: currentStatus)
            )
        }
    
    private func createTableData(for status: StatusItem) -> DetailsViewState.TableData {
        let numberOfRows: Int
        switch status {
        case .inStock:
            numberOfRows = 2
        case .inTest:
            numberOfRows = test.count + 1
        case .writeOff:
            numberOfRows = writeOffs.count + 1
        }
        
        return DetailsViewState.TableData(numberOfRows: numberOfRows, cellType: .header(item))
    }
    
    func cellType(for indexPath: IndexPath) -> DetailsViewState.TableData.CellType {
        switch indexPath.row {
        case 0:
            return .header(item)
        case 1 where currentStatus == .inStock:
            return .info(item, allWriteOffs)
        default :
            let items = currentStatus == .inTest ? test : writeOffs
            let isTest = currentStatus == .inTest
            let index = indexPath.row > 0 ? indexPath.row - 1 : 0
            //print("index \(index)  items count \(items.count)")
            return .writeOff(items[index], isTest)
        }
    }
    
    func removeWriteOffItem(at id: Int) {
       
      //  guard let index = allWriteOffs.firstIndex(where: { $0.id == id }) else {
        //    return
        //}
        //allWriteOffs.remove(at: index)
        viewState = DetailsViewState(
            selectedStatus: currentStatus,
            isWriteOffButtonHidden: currentStatus != .inStock,
            tableData: createTableData(for: currentStatus)
        )
       // print("number of writeOffs \(viewState?.tableData.numberOfRows)")
    }
    
    var rackConfiguration: RackView.Configuration {
        RackView.Configuration(rack: item.location.full)
    }
    
    func fetchProjects() async throws {
        let objects = try await googleSheetsManager.fetchData(spreadsheetId: Spreadsheet.StorageSheet.id, range: Spreadsheet.StorageSheet.projectList)
        projects = processResponseProjects(objects)
    }
    
    func writeOff() async throws {
        
        let name = item.details.commercialName
        let unit = item.stock.unit
        let count = "\(countItem.value)"
        let user = user?.name ?? ""
        let project = "\(project.value?.systemNumber ?? -1)-\(project.value?.name ?? "")"
        let status = String(currentWriteOffStatus.rawValue)
        let description = descriptionItem.value
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU") // Русская локаль
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short

        let currentDate = Date()
        let dateString = dateFormatter.string(from: currentDate)
        //let newItemWriteOff = ItemWriteOff(id: writeOffs.count, name : name, quantity: Double(count) ?? 0, unit: unit, author: user, project: project, status: status, comment: nil, date: dateString)
        //item.stock.allocatedQuantity += Double(count) ?? 0
        //allWriteOffs.append(newItemWriteOff)
        
        try await googleSheetsManager.writeValues(spreadsheetId: Spreadsheet.WriteOffSheet.id, range: Spreadsheet.WriteOffSheet.writeOffList(), values: [[name, unit, count, user, project, status,description, dateString]])
        let itemsWriteOff = try await googleSheetsManager.fetchData(spreadsheetId: Spreadsheet.WriteOffSheet.id, range: Spreadsheet.WriteOffSheet.writeOffList())
        allWriteOffs = processResponseWriteOff(itemsWriteOff)
        Task {
            await coreDataService.saveWriteOff(allWriteOffs)
        }
        removeWriteOffItem(at: allWriteOffs.count - 1)
        isLoading.send()
    }
    
    func deleteWriteOff(item: ItemWriteOff) async throws {
        
        let sheetId = try await googleSheetsManager.fetchSheetId()
        let row = item.id
        guard let index = allWriteOffs.firstIndex(where: { $0.id == row }) else {
            return
        }
      //  print("allWriteOffs[\(allWriteOffs)]")
        switch item.status {
        case "На списание":
            self.item.stock.allocatedQuantity -= allWriteOffs[index].quantity
        default:
            self.item.stock.testedQuantity -= allWriteOffs[index].quantity
        }
        
        allWriteOffs.remove(at: index)
        Task {
            await coreDataService.saveWriteOff(allWriteOffs)
        }
        removeWriteOffItem(at: item.id)
       // print("index remove\(index) , allWriteOffs[\(allWriteOffs)]")
        try await googleSheetsManager.deleteRow(sheetId: sheetId, rowNumber: row)
        isLoading.send()
    }
    
}

extension DetailsViewModel {
    private func processResponseProjects(_ response: GoogleSheetResponse) -> [Project] {
        var projects: [Project] = []
        for (index, obj) in response.values.enumerated() {
            guard obj.count > 1, index > 0 else {
                continue
            }
            
            let name = obj[0]
            let systemNumber: Int? = Int(obj[1])
            
            let project = Project(name: name, systemNumber: systemNumber)
            
            projects.append(project)
        }
        projectInFilters.send(projects)
        return projects
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
            
            //processedItemWriteOffs.append(itemWriteOff)
           
            // Обновление основного массива items
            if
                item.details.commercialName == name ||
                item.details.commercialName.dropFirst(3) == name {
                if status == "Переместить на Телипко М.Г." {
                    item.stock.testedQuantity += quantity
                } else {
                    item.stock.allocatedQuantity += quantity
                }
                processedItemWriteOffs.append(itemWriteOff)
            }
        }
       // print("writeOff count = \(processedItemWriteOffs.count)")
        return processedItemWriteOffs
    }
//
//    private func processResponseUsers(_ response: GoogleSheetResponse) -> [User] {
//        var users: [User] = []
//        
//        for (index, obj) in response.values.enumerated() {
//            guard obj.count > 1, index > 0 else { continue }
//            
//            let name = obj[1]
//            users.append(User(name: name))
//        }
//        return users
//    }
    
    private func showCachedData() {
        let userName = UserDefaults.standard.string(forKey: "name")
        let cachedUserEntities = coreDataService.fetchAllUsers()
        users = cachedUserEntities.map { entity in
            let user = User(from: entity)
            if user.name == userName {
                self.user = user
                selectUser.send(true)
            }
            return user
        }
        
      //  print(users)
    }
    
    private func processActualCountItem(item: inout Item, writeOffItems: [ItemWriteOff]) {
         
        for itemWriteOff in writeOffItems {
            if itemWriteOff.status == "Переместить на Телипко М.Г." {
                item.stock.testedQuantity += itemWriteOff.quantity
            } else {
                item.stock.allocatedQuantity += itemWriteOff.quantity
            }
           // print("\(item.details.commercialName) = \(item.stock)")
        }
    }
}
