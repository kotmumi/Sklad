//
//  Coordinator.swift
//  Sklad
//
//  Created by Кирилл Котыло on 29.07.25.
//

import UIKit

protocol Coordinator: AnyObject {
    
    var childCoordinators: [Coordinator] { get set }
    var parentCoordinator: Coordinator? { get set }
    
    func start()
    func finish()
}

extension Coordinator {
    
    func addChild(_ coordinator: Coordinator) {
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
    }
    
    func removeChild(_ coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
    
    func removeAllChildren() {
        childCoordinators.forEach { $0.finish() }
        childCoordinators.removeAll()
    }
    
    func finish() {
        parentCoordinator?.removeChild(self)
        removeAllChildren()
    }
}
