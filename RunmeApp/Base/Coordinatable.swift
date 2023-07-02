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

    func showErrorAlert(_ error: Error)
}


extension Coordinatable {
    func addChildCoordinator(_ coordinator: Coordinatable) {}
    func removeChildCoordinator(_ coordinator: Coordinatable) {}

    func showErrorAlert(_ error: Error) {
        DispatchQueue.main.async {
            self.navigationController.showAlert(title: "Ошибка!", message: error.localizedDescription) {}
        }
    }
}
