//
//  FilterViewController.swift
//  StockTrace
//
//  Created by Кирилл Котыло on 2.07.25.
//
import UIKit

protocol FilterDelegate: AnyObject {
    func filter(selectedChars: Set<String>, selectedNumbers: Set<String>)
    func setRactFilter(selectedChars: Set<String>, selectedNumbers: Set<String>)
}

class FilterViewController: UIViewController {
    
    private var charRacts: [String] = ["G", "F", "D", "E", "H", "И", "K"]
    private var numberRacts: [String] = ["1-1", "1-2", "1-3", "1-4", "2-1", "2-2", "2-3", "2-4",
    "3-1", "3-2", "3-3", "3-4", "4-1", "4-2", "4-3", "4-4", "5-1", "5-2", "5-3", "5-4"]
    
    private var selectedCharRacts: Set<String>
    private var selectedNumberRacts: Set<String>
    
    private lazy var racts: [[String]] = [charRacts, numberRacts]
    private let filterView = FilterView()
     var filterDelegate: FilterDelegate?
    
    init(selectedCharRacts: Set<String>, selectedNumberRacts: Set<String>) {
        self.selectedCharRacts = selectedCharRacts
        self.selectedNumberRacts = selectedNumberRacts
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = filterView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        tabBarController?.isTabBarHidden = true
        navigationItem.title = "Фильтр"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сбросить", style: .plain, target: self, action: #selector(cancel))
        
        filterView.RactsCharCollectionView.delegate = self
        filterView.RactsCharCollectionView.dataSource = self
        filterView.RactsCharCollectionView.register(FilterCell.self, forCellWithReuseIdentifier: FilterCell.identifier)
        
        filterView.acceptButton.addTarget(self, action: #selector(tapAcceptButton), for: .touchUpInside)
    }
    @objc private func cancel() {
        selectedCharRacts.removeAll()
        selectedNumberRacts.removeAll()
        print("selectedCharRacts - \(selectedCharRacts)")
        print("selectedNumberRacts - \(selectedNumberRacts)")
        filterView.RactsCharCollectionView.reloadData()
    }
    
    @objc private func tapAcceptButton() {
        filterDelegate?.filter(selectedChars: selectedCharRacts, selectedNumbers: selectedNumberRacts)
        filterDelegate?.setRactFilter(selectedChars: selectedCharRacts, selectedNumbers: selectedNumberRacts)
        navigationController?.popViewController(animated: true)
    }
}

extension FilterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        racts[section].count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        racts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCell.identifier, for: indexPath) as? FilterCell else { return UICollectionViewCell() }
        
        let isActiveCell = selectedCharRacts.contains(racts[indexPath.section][indexPath.row]) || selectedNumberRacts.contains(racts[indexPath.section][indexPath.row])
        
        cell.config(from: racts[indexPath.section][indexPath.row], isActiveCell)
        cell.layer.cornerRadius = cell.frame.height / 2
        
        
        if isActiveCell {
            _ = cell.select()
        }
        return cell
    }
    
}

extension FilterViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: view.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch indexPath.section {
        case 0:
            return CGSize(width: 48, height: 48)
        default:
            return CGSize(width: 60, height: 48)
        }
        
    }
}

extension FilterViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? FilterCell else { return }
        
        switch indexPath.section {
        case 0:
            if cell.select() {
                selectedCharRacts.insert(racts[indexPath.section][indexPath.row])
            } else {
                selectedCharRacts.remove(racts[indexPath.section][indexPath.row])
            }
        case 1:
            if cell.select() {
                selectedNumberRacts.insert(racts[indexPath.section][indexPath.row])
            } else {
                selectedNumberRacts.remove(racts[indexPath.section][indexPath.row])
            }
        default:
            break
        }
    }
}


