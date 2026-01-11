////
////  DetailsViewController.swift
////  Sklad
////
////  Created by Кирилл Котыло on 24.09.25.
////
//import UIKit
//import Foundation
//import Combine
//
//class DetailsViewControllerLegacy: UIViewController {
//
//    private let viewModel: DetailsViewModel
//    private weak var coordinator: DetailsCoordinator?
//
//    private let detailsView: DetailsView = DetailsView()
//    private var cancellables = Set<AnyCancellable>()
//
//    init(coordinator: DetailsCoordinator, viewModel: DetailsViewModel) {
//        self.coordinator = coordinator
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func loadView() {
//        super.loadView()
//        view = detailsView
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//      //  bindViewModel()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        configNavigationBar()
//    }
//
//    private func setupUI() {
//
//        detailsView.writeOffButton.addTarget(self, action: #selector(handleWriteOff), for: .touchUpInside)
//        detailsView.segmentedControl.segmentedControl.addTarget(self, action: #selector(handleValueChanged), for: .valueChanged)
//        detailsView.tableView.dataSource = self
//        detailsView.tableView.delegate = self
//
//        detailsView.tableView.register(HeaderViewCell.self, forCellReuseIdentifier: HeaderViewCell.reuseIdentifier)
//        detailsView.tableView.register(InfoViewCell.self, forCellReuseIdentifier: InfoViewCell.reuseIdentifier)
//        detailsView.tableView.register(WriteOffViewCell.self, forCellReuseIdentifier: WriteOffViewCell.reuseIdentifier)
//    }
//
//    private func configNavigationBar() {
//        guard let navController = navigationController as? CustomNavigationController else {
//            fatalError("Navigation controller must be MainNavigationController")
//        }
//        navController.navigationBar.isHidden = false
//        navController.isSearchBarHidden = true
//        navigationItem.title = "Остатки"
//
//        let rackView = RackView()
//        rackView.config(rack: viewModel.item.location.full)
//        let customBarButtonItem = UIBarButtonItem(customView: rackView)
//        navigationItem.rightBarButtonItem = customBarButtonItem
//
//    }
//
////    private func bindViewModel() {
////        viewModel.$status
////            .receive(on: DispatchQueue.main)
////            .sink { [weak self] status in
////                self?.detailsView.segmentedControl.segmentedControl.selectedSegmentTintColor = status.color
////                switch status {
////                case .inStock:
////                    self?.detailsView.writeOffButton.isHidden = false
////                default:
////                    self?.detailsView.writeOffButton.isHidden = true
////                }
////                self?.detailsView.tableView.reloadData()
////            }
////            .store(in: &cancellables)
////    }
//
//
//    @objc
//    private func handleValueChanged() {
////        switch detailsView.segmentedControl.segmentedControl.selectedSegmentIndex {
////        case 0:
////            viewModel.status = .inStock
////        case 1:
////            viewModel.status = .inTest
////        case 2:
////            viewModel.status = .writeOff
////        default:
////            break
////        }
//    }
//
//    @objc
//    private func handleWriteOff() {
//        coordinator?.goToWriteOff()
//    }
//}
//
//
//extension DetailsViewControllerLegacy: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch detailsView.segmentedControl.segmentedControl.selectedSegmentIndex {
//        case 0:
//            return 2
//        case 1:
//          //  return viewModel.tests.count + 1
//        case 2:
//            //return viewModel.writeOffs.count + 1
//        default:
//            return 1
//        }
//
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let headerCell = tableView.dequeueReusableCell(withIdentifier: HeaderViewCell.reuseIdentifier, for: indexPath) as? HeaderViewCell else {
//            return UITableViewCell()
//        }
//
//        guard let infoCell = tableView.dequeueReusableCell(withIdentifier: InfoViewCell.reuseIdentifier, for: indexPath) as? InfoViewCell else {
//            return UITableViewCell()
//        }
//
//        guard let writeOffCell = tableView.dequeueReusableCell(withIdentifier: WriteOffViewCell.reuseIdentifier, for: indexPath) as? WriteOffViewCell else {
//            return UITableViewCell()
//        }
//
//        switch indexPath.row {
//            case 0:
//            headerCell.config(item: viewModel.item)
//            return headerCell
//        case 1 where detailsView.segmentedControl.segmentedControl.selectedSegmentIndex == 0:
//         //   infoCell.config(item: viewModel.item, writeOff: viewModel.writeOff)
//            return infoCell
//        default:
//            if detailsView.segmentedControl.segmentedControl.selectedSegmentIndex == 1 {
//            //    writeOffCell.config(item: viewModel.tests[indexPath.row-1], isTest: true)
//            } else  {
//              //  writeOffCell.config(item: viewModel.writeOffs[indexPath.row-1], isTest: false)
//            }
//            return writeOffCell
//        }
//    }
//}
//
//extension DetailsViewControllerLegacy: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//}
