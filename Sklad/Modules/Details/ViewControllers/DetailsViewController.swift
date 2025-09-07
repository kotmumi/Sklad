//
//  DetailsViewController.swift
//  Sklad
//
//  Created by Кирилл Котыло on 3.08.25.
//

import UIKit

class DetailsViewController: UIViewController {
    var coordinator: DetailsCoordinator?
    
    private let detailsView: DetailsView = DetailsView()
    
    private let item: Item
    private let writeOff: [ItemWriteOff]
    lazy var tests: [ItemWriteOff] = writeOff.filter { $0.status == "Взял на тесты"}
    lazy var writeOffs: [ItemWriteOff] = writeOff.filter { $0.status == "На списание"}
    
   
    
    init(item: Item, writeOff: [ItemWriteOff]) {
        self.item = item
        self.writeOff = writeOff
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = detailsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configNavigationBar()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configNavigationBar()
    }

    
    private func setupUI() {
        detailsView.writeOffButton.addTarget(self, action: #selector(handleWriteOff), for: .touchUpInside)
        detailsView.segmentedControl.segmentedControl.addTarget(self, action: #selector(handleValueChanged), for: .valueChanged)
        detailsView.tableView.dataSource = self
        detailsView.tableView.delegate = self
        
        detailsView.tableView.register(HeaderViewCell.self, forCellReuseIdentifier: HeaderViewCell.reuseIdentifier)
        detailsView.tableView.register(InfoViewCell.self, forCellReuseIdentifier: InfoViewCell.reuseIdentifier)
        detailsView.tableView.register(WriteOffViewCell.self, forCellReuseIdentifier: WriteOffViewCell.reuseIdentifier)
    }
    
    private func configNavigationBar() {
        guard let navController = navigationController as? CustomNavigationController else {
            fatalError("Navigation controller must be MainNavigationController")
        }
        navController.navigationBar.isHidden = false
        navController.isSearchBarHidden = true
        navigationItem.title = "Остатки"
        
        let rackView = RackView()
        rackView.config(rack: item.location.full)
        let customBarButtonItem = UIBarButtonItem(customView: rackView)
        navigationItem.rightBarButtonItem = customBarButtonItem
        
    }
    
    @objc
    private func handleValueChanged() {
        detailsView.tableView.reloadData()
        switch detailsView.segmentedControl.segmentedControl.selectedSegmentIndex {
        case 0:
            detailsView.writeOffButton.isHidden = false
        default:
            detailsView.writeOffButton.isHidden = true
        }
    }
    
    @objc
    private func handleWriteOff() {
        coordinator?.goToWriteOff()
    }
}


extension DetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch detailsView.segmentedControl.segmentedControl.selectedSegmentIndex {
        case 0:
            return 2
        case 1:
            return tests.count + 1
        case 2:
            return writeOffs.count + 1
        default:
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let headerCell = tableView.dequeueReusableCell(withIdentifier: HeaderViewCell.reuseIdentifier, for: indexPath) as? HeaderViewCell else {
            return UITableViewCell()
        }
        
        guard let infoCell = tableView.dequeueReusableCell(withIdentifier: InfoViewCell.reuseIdentifier, for: indexPath) as? InfoViewCell else {
            return UITableViewCell()
        }
        
        guard let writeOffCell = tableView.dequeueReusableCell(withIdentifier: WriteOffViewCell.reuseIdentifier, for: indexPath) as? WriteOffViewCell else {
            return UITableViewCell()
        }
        
        switch indexPath.row {
            case 0:
            headerCell.config(item: item)
            return headerCell
        case 1 where detailsView.segmentedControl.segmentedControl.selectedSegmentIndex == 0:
            infoCell.config(item: item, writeOff: writeOff)
            return infoCell
        default:
            if detailsView.segmentedControl.segmentedControl.selectedSegmentIndex == 1 {
                writeOffCell.config(item: tests[indexPath.row-1], isTest: true)
            } else  {
                writeOffCell.config(item: writeOffs[indexPath.row-1], isTest: false)
            }
            return writeOffCell
        }
    }
}

extension DetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
