//
//  ViewController.swift
//  Sklad
//
//  Created by Кирилл Котыло on 29.07.25.
//

import UIKit
import GoogleSignIn

class MainViewController2: UIViewController {
    
    weak var coordinator: MainCoordinator?
    private var objects: GoogleSheetResponse?
    private var writeObjects: GoogleSheetResponse?
    private let googleSheetsManager: GoogleSheetsService = GoogleSheetsDataService()
    
    private var items: [Item] = []
    private var itemsInCollection = [Item]()
    
    private var itemsWriteOff: [ItemWriteOff] = []
    
    private var selectedChars = Set<String>()
    private var selectedNumbers = Set<String>()
   
    private let mainView = MainView()
    let refreshControl = UIRefreshControl()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.isTabBarHidden = false
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupUI()
        Task {
            print("will fetchData")
            try await fetchData()
            print("did fetchData")
        }
    }
    
    private func fetchData() async throws {
        objects = try await googleSheetsManager.fetchData(spreadsheetId: Spreadsheet.StorageSheet.id, range: Spreadsheet.StorageSheet.storageList)
        guard let objects else {return}
        itemsAdd(objects)
        
        writeObjects = try await googleSheetsManager.fetchData(spreadsheetId: Spreadsheet.WriteOffSheet.id,range: Spreadsheet.WriteOffSheet.writeOffList())
        guard let obj = writeObjects else {return}
        writeCountAdd(obj)
        
        itemsInCollection = items
        
        mainView.collectionView.reloadData()
    }
    
    private func setupUI() {
        
        navigationItem.searchController?.searchBar.delegate = self
        navigationItem.searchController?.searchBar.searchTextField.delegate = self
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
       
        mainView.collectionView.register(ProductCellView.self, forCellWithReuseIdentifier: ProductCellView.identifier)
        
        mainView.collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        guard let navControll =  navigationController as? CustomNavigationController else {return}
        navControll.filterButton.addTarget(self, action: #selector(tapFilterButton), for: .touchUpInside)
    }

    @objc
    private func tapFilterButton() {
        coordinator?.goToFilter(selectedCharRacts: selectedChars, selectedNumberRacts: selectedNumbers)
    }
    
    @objc
    private func refreshData() async throws {
            try await fetchData()
            refreshControl.endRefreshing()
    }
}

extension MainViewController2: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        itemsInCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCellView.identifier, for: indexPath) as? ProductCellView else {
            return UICollectionViewCell()
        }
        cell.config(whit: itemsInCollection[indexPath.row])
        return cell
    }
}

extension MainViewController2: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 44) / 2
        return CGSize(width: width, height: width)
    }

}

extension MainViewController2: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let coordinator else { return }
        let writeOff = itemsWriteOff.filter { $0.name == itemsInCollection[indexPath.row].details.commercialName }
        print("writeOff: \(writeOff)")
        coordinator.goToDetails(item: itemsInCollection[indexPath.row], writeOff: writeOff )
    }
}

extension MainViewController2: UITextFieldDelegate {

    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        if textField.text != "" {
            filter(selectedChars: selectedChars, selectedNumbers: selectedNumbers)
            itemsInCollection = itemsInCollection.filter { $0.details.commercialName.lowercased().contains(textField.text!.lowercased()) }
            mainView.collectionView.reloadData()
        } else {
            filter(selectedChars: selectedChars, selectedNumbers: selectedNumbers)
        }
    }
}

extension MainViewController2 {
    
    private func itemsAdd(_ objects: GoogleSheetResponse) {
        items.removeAll()
        for obj in objects.values {
            if obj.count > 9 && obj != objects.values.first {
                let name = obj[1]
                let actualName = obj[2]
                let unit = obj[3]
                let stringCount = obj[4].replacingOccurrences(of: ",", with: ".")
                guard let quantity = Double(stringCount.replacingOccurrences(of: "\\s", with: "",options: .regularExpression)) else {
                    continue
                }
                let price = obj[5]
                let totalPrice = obj[6]
                _ = "\(obj[8]) \(obj[9])"
                let charRack = obj[8]
                let numberRack = obj[9]
                var comment: String?
                do {
                    comment = obj[10]
                }
                items.append(.init(details: Details(commercialName: name,
                                     technicalName: actualName,
                                     discription: comment
                                    ),
                    pricing: Pricing(price: price,
                                     totalPrice: totalPrice
                                    ),
                    stock: StockInfo(totalQuantity: quantity,
                                     unit: unit
                                    ),
                    location: Rack(section: charRack,
                                   number: numberRack
                                  )
                ))
            }
        }
    }
    
    private func writeCountAdd(_ objects: GoogleSheetResponse) {
        for i in 2..<objects.values.count {
            guard objects.values[i].indices.contains(0),
                  objects.values[i].indices.contains(1),
                  objects.values[i].indices.contains(2),
                  objects.values[i].indices.contains(3),
                  objects.values[i].indices.contains(4),
                  objects.values[i].indices.contains(5)

            else {
                print("Ошибка: неверный формат данных в строке \(i)")
                continue
            }
            
            let name = objects.values[i][0]
            let unit = objects.values[i][1]
            let countString = objects.values[i][2]
                .replacingOccurrences(of: ",", with: ".")
                .replacingOccurrences(of: " ", with: "")
            let count = Double(countString) ?? 0.0
            let author = objects.values[i][3]
            let project = objects.values[i][4]
            let status = objects.values[i][5]
            
            itemsWriteOff.append(ItemWriteOff(id: i, name: name, quantity: count, unit: unit, author: author, project: project, status: status))
            
            if let index = self.items.firstIndex(where: {
                $0.details.commercialName == name || $0.details.commercialName.dropFirst(3) == name
            }) {
                if status == "Взял на тесты" {
                    self.items[index].stock.testedQuantity += count
                } else {
                    self.items[index].stock.allocatedQuantity += count
                }
            }
        }
    }
    
    private func googleSignIn() {
        let scopes = ["https://www.googleapis.com/auth/spreadsheets"]
        
        GIDSignIn.sharedInstance.signIn(
            withPresenting: self,
            hint: nil,
            additionalScopes: scopes
        ) { result, error in
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else { return }
            let email = user.profile?.email ?? "No email"
            print("Успешный вход пользователя: \(email)")
        }
    }
    
    private func showAuthError() {
        let alert = UIAlertController(
            title: "Требуется авторизация",
            message: "Пожалуйста, войдите через Google",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Войти", style: .default) { _ in
            // Запускаем процесс авторизации
            self.googleSignIn()
        })
        present(alert, animated: true)
    }
    
}
    
    
    extension MainViewController2: UISearchBarDelegate {
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            guard let searchControll = self.navigationItem.searchController else {
                return
            }
            guard let navigationController = self.navigationController as? CustomNavigationController else { return }
            
            navigationController.filterButton.isHidden = true
            searchControll.searchBar.showsCancelButton = true
            searchControll.searchBar.searchTextField.layer.borderColor = UIColor.black.cgColor
            DispatchQueue.main.async() {
                searchControll.searchBar.becomeFirstResponder()
            }
             navigationController.navigationItem.hidesBackButton = true
//            let vc = SearchViewController(search: searchControll)
//            vc.navigationItem.hidesBackButton = true
//            vc.searchDelegate = self
//              navigationController.pushViewController(vc, animated: false)
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            
            guard let navigationController = self.navigationController as? CustomNavigationController else { return }
            
            guard let searchControll = self.navigationItem.searchController else {
                return
            }
            searchControll.searchBar.searchTextField.layer.borderColor = UIColor.lightGray.cgColor
            searchControll.searchBar.showsCancelButton = false
            navigationController.filterButton.isHidden = false
        }
        
    }
    
    //extension MainViewController: MainViewControllerDelegate {
    //    func didSelectSearch() {
    //        self.navigationItem.searchController?.searchBar.showsCancelButton = false
    //    }
    //}
    
extension MainViewController2: FilterDelegate {
    func setRactFilter(selectedChars: Set<String>, selectedNumbers: Set<String>) {
        self.selectedChars = selectedChars
        self.selectedNumbers = selectedNumbers
    }
    
    func filter(selectedChars: Set<String>, selectedNumbers: Set<String>) {
        if selectedChars.isEmpty && selectedNumbers.isEmpty {
            itemsInCollection = items
            mainView.collectionView.reloadData()
            return
        }
        
        itemsInCollection = items.filter { item in
            
            let charFilter = selectedChars.isEmpty || selectedChars.contains(item.location.section)
            
            let numberFilter = selectedNumbers.isEmpty || selectedNumbers.contains(item.location.number)
            
            return charFilter && numberFilter
        }
        mainView.collectionView.reloadData()
    }
}
