//
//  Coordinatable.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 22.06.2023.
//

import UIKit

protocol Coordinatable: AnyObject {
    var parentCoordinator: Coordinatable? { get set }
    var childCoordinators: [Coordinatable] { get }
    func start() -> UIViewController
    func addChildCoordinator(_ coordinator: Coordinatable)
    func removeChildCoordinator(_ coordinator: Coordinatable)
}

protocol AppCoordinatorProtocol: Coordinatable {
    func goToLogin() -> UIViewController
    func goHome() -> UIViewController
}

//protocol ModuleCoordinatable: Coordinatable {
//    var module: Module? { get }
//    var moduleType: Module.ModuleType { get }
//}

extension Coordinatable {
    func addChildCoordinator(_ coordinator: Coordinatable) {}
    func removeChildCoordinator(_ coordinator: Coordinatable) {}
}
