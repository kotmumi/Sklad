//
//  AccountViewModel.swift
//  Sklad
//
//  Created by Кирилл Котыло on 9.10.25.
//

import Combine
import Foundation

final class AccountViewModel {
    var isSelectUser = CurrentValueSubject<Bool,Never>(false)
    var selectUser = CurrentValueSubject<Bool,Never>(false)
    
    private let googleSheetsManager: GoogleSheetsService
    private let coreDataService: CoreDataServiceProtocol
    
    var users: [User] = []
    var usersInTable: [User] = []
    var user: User?
    
    private var cancellables = Set<AnyCancellable>()
    
    init( googleSheetsManager:GoogleSheetsService, coreDataService: CoreDataServiceProtocol) {
        self.coreDataService = coreDataService
        self.googleSheetsManager = googleSheetsManager
        showCachedData()
        bind()
    }
    
    private func bind() {
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
    }
}

extension AccountViewModel {
    
    private func showCachedData() {
        let userName = UserDefaults.standard.string(forKey: "name")
        let cachedUserEntities = coreDataService.fetchAllUsers()
        users = cachedUserEntities.map { entity in
            let user = User(from: entity)
            if user.name == userName {
                self.user = user
            }
            return user
        }
    }
}
