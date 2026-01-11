//
//  AccountViewController.swift
//  StockTrace
//
//  Created by Кирилл Котыло on 25.06.25.
//

import UIKit
import GoogleSignIn
import Combine

class AccountViewController: UIViewController {
    private let authVC = AuthViewController()
    private let accountView = AccountView()
    private var viewModel = AccountViewModel(googleSheetsManager: GoogleSheetsDataService(), coreDataService: CoreDataService())
    weak var coordinator: AppCoordinator?
    
    private var cancellables = Set<AnyCancellable>()
    
    override func loadView() {
        view = accountView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        
    }
    
    private func setupUI() {
        accountView.userProfileView.userView.height = 120
        accountView.userProfileView.userView.userTableView.dataSource = self
        accountView.userProfileView.userView.userTableView.delegate = self
        accountView.userProfileView.userView.userTableView.register(UserViewCell.self, forCellReuseIdentifier: UserViewCell.reuseIdentifier)
        accountView.userProfileView.userView.updateTableViewHeight()
        
        accountView.userProfileView.signOutButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.signOut()
        }, for: .touchUpInside)
        
        let tapUserGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapUserGestureRecognizer))
        accountView.userProfileView.userView.containerView.addGestureRecognizer(tapUserGestureRecognizer)
        let user =  GIDSignIn.sharedInstance.currentUser
        accountView.config(user: user)
    }
    
    private func bind() {
        viewModel.isSelectUser
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isSelect in
                guard let self else {return }
                if isSelect {
                    self.viewModel.usersInTable = self.viewModel.users
                } else {
                    self.viewModel.usersInTable = self.viewModel.users.filter {$0.name == self.viewModel.user?.name }
                }
                self.accountView.userProfileView.userView.tapImage(isOpen: isSelect)
                self.accountView.userProfileView.userView.userTableView.reloadData()
                self.accountView.userProfileView.userView.updateTableViewHeight()
         
            }
            .store(in: &cancellables)
    }
    
    @objc
    private func handleTapUserGestureRecognizer() {
        viewModel.isSelectUser.send(!viewModel.isSelectUser.value)
        print(viewModel.usersInTable)
    }
    
    private func signOut() {
        GIDSignIn.sharedInstance.signOut()
        coordinator?.start()
    }
}

extension AccountViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.usersInTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserViewCell.reuseIdentifier, for: indexPath) as? UserViewCell else { return UITableViewCell() }
        if viewModel.usersInTable.count > 0 {
            cell.config(user: viewModel.usersInTable[indexPath.row], isSelected: viewModel.user?.name == viewModel.usersInTable[indexPath.row].name)
        }
        return cell
    }
}

extension AccountViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if viewModel.user?.name != viewModel.usersInTable[indexPath.row].name {
            viewModel.user = viewModel.usersInTable[indexPath.row]
        } else {
            viewModel.user = nil
        }
        UserDefaults.standard.set(viewModel.user?.name, forKey: "name")
        viewModel.isSelectUser.send(false)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func formatNumber(_ value: Double) -> String {
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            return String(Int(value))
        } else {
            return String(value)
        }
    }
}
