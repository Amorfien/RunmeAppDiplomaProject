//
//  Coordinatable.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 22.06.2023.
//

import UIKit

protocol Coordinatable: AnyObject {
    func start()
    var navigationController: UINavigationController { get set}
    var childCoordinators: [Coordinatable] { get }

    var flowCompletionHandler: (() -> Void)? { get set }

    func addChildCoordinator(_ coordinator: Coordinatable)
    func removeChildCoordinator(_ coordinator: Coordinatable)
}


extension Coordinatable {
    func addChildCoordinator(_ coordinator: Coordinatable) {}
    func removeChildCoordinator(_ coordinator: Coordinatable) {}
}
