//
//  MainViewController.swift
//  Sklad
//
//  Created by Кирилл Котыло on 26.08.25.
//
import UIKit
import CoreData
import Combine

class MainViewController: UIViewController {
    
    weak var coordinator: MainCoordinator?
    private let viewModel: MainViewModel
    private let mainView = MainView()
    private let refreshControl = UIRefreshControl()
    
    private var fetchedResultsController: NSFetchedResultsController<ItemEntity>!
    private var diffableDataSource: UICollectionViewDiffableDataSource<Int, NSManagedObjectID>?
    
    var cancellables = Set<AnyCancellable>()
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.isTabBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupFetchedResultsController()
        setupDiffableDataSource()
        bindViewModel()
        
        Task {
            await viewModel.loadData()
        }
    }
    
    private func setupUI() {
        
        navigationItem.searchController?.searchBar.delegate = self
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        mainView.collectionView.register(ProductCellView.self,
                                           forCellWithReuseIdentifier: ProductCellView.identifier)
        mainView.collectionView.delegate = self
        mainView.collectionView.refreshControl = refreshControl
        //refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshControl.addAction(UIAction { [weak self] _ in
            guard let self else {return}
            self.refreshData()
        }, for: .valueChanged)
        mainView.filterButton.addTarget(self, action: #selector(tapFilterButton), for: .touchUpInside)
    }
    
    private func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "commercialName", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: CoreDataManager.shared.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    private func setupDiffableDataSource() {
        diffableDataSource = UICollectionViewDiffableDataSource<Int, NSManagedObjectID>(
            collectionView: mainView.collectionView
        ) { [weak self] collectionView, indexPath, objectID in
            
            guard self != nil else { return UICollectionViewCell() }
            
            let context = CoreDataManager.shared.viewContext
            guard let object = try? context.existingObject(with: objectID),
                  let itemEntity = object as? ItemEntity,
                  let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ProductCellView.identifier,
                    for: indexPath
                  ) as? ProductCellView else {
                return UICollectionViewCell()
            }
            let item = Item(from: itemEntity)
            cell.config(whit: item)
            
            return cell
        }
        applySnapshot()
    }
    
    private func bindViewModel() {
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if !isLoading {
                    self?.refreshControl.endRefreshing()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                if let errorMessage = errorMessage {
                    self?.showErrorAlert(message: errorMessage)
                }
            }
            .store(in: &cancellables)
    }
    
    @objc private func tapFilterButton() {
        coordinator?.goToFilter(selectedCharRacts: viewModel.selectedChars,
                               selectedNumberRacts: viewModel.selectedNumbers)
    }
    
    private func refreshData() {
        Task {
            await viewModel.refreshData()
            await MainActor.run {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        guard let dataSource = diffableDataSource,
              let fetchedObjects = fetchedResultsController.fetchedObjects else {
            return
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, NSManagedObjectID>()
        snapshot.appendSections([0])
        
        let objectIDs = fetchedObjects.map { $0.objectID }
        snapshot.appendItems(objectIDs)
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension MainViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        applySnapshot()
    }
}

// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let objectID = diffableDataSource?.itemIdentifier(for: indexPath),
              let context = try? CoreDataManager.shared.viewContext.existingObject(with: objectID),
              let itemEntity = context as? ItemEntity else {
            return
        }
        
        let item = Item(from: itemEntity)
        let writeOff = viewModel.getWriteOffs(for: item.details.commercialName)
        
        coordinator?.goToDetails(item: item, writeOff: writeOff)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 44) / 2
        return CGSize(width: width, height: width)
    }
}

// MARK: - UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        guard let searchController = navigationItem.searchController,
              let navController = navigationController as? CustomNavigationController else {
            return
        }
        
        navController.filterButton.isHidden = true
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.searchTextField.layer.borderColor = UIColor.black.cgColor
        searchController.searchBar.becomeFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        guard let navController = navigationController as? CustomNavigationController,
              let searchController = navigationItem.searchController else {
            return
        }
        
        searchController.searchBar.searchTextField.layer.borderColor = UIColor.lightGray.cgColor
        searchController.searchBar.showsCancelButton = false
        navController.filterButton.isHidden = false
        searchController.searchBar.resignFirstResponder()
        
        viewModel.clearSearch()
        fetchedResultsController.fetchRequest.predicate = nil
        try? fetchedResultsController.performFetch()
        applySnapshot()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            fetchedResultsController.fetchRequest.predicate = nil
        } else {
            fetchedResultsController.fetchRequest.predicate = NSPredicate(
                format: "commercialName CONTAINS[cd] %@", searchText
            )
        }
        
        try? fetchedResultsController.performFetch()
        applySnapshot()
    }
}

// MARK: - FilterDelegate
extension MainViewController: FilterDelegate {
    func setRactFilter(selectedChars: Set<String>, selectedNumbers: Set<String>) {
        viewModel.setRackFilter(selectedChars: selectedChars, selectedNumbers: selectedNumbers)
        applyFilterPredicate()
    }
    
    func filter(selectedChars: Set<String>, selectedNumbers: Set<String>) {
        viewModel.setRackFilter(selectedChars: selectedChars, selectedNumbers: selectedNumbers)
        applyFilterPredicate()
    }
    
    private func applyFilterPredicate() {
        let charPredicate: NSPredicate?
        if !viewModel.selectedChars.isEmpty {
            charPredicate = NSPredicate(format: "section IN %@", Array(viewModel.selectedChars))
        } else {
            charPredicate = nil
        }
        
        let numberPredicate: NSPredicate?
        if !viewModel.selectedNumbers.isEmpty {
            numberPredicate = NSPredicate(format: "number IN %@", Array(viewModel.selectedNumbers))
        } else {
            numberPredicate = nil
        }
        
        let finalPredicate: NSPredicate?
        if let charPredicate = charPredicate, let numberPredicate = numberPredicate {
            finalPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [charPredicate, numberPredicate])
        } else {
            finalPredicate = charPredicate ?? numberPredicate
        }
        
        fetchedResultsController.fetchRequest.predicate = finalPredicate
        try? fetchedResultsController.performFetch()
        applySnapshot()
    }
}
