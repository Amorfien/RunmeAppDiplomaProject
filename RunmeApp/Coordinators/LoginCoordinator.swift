//
//  LoginCoordinator.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 22.06.2023.
//

import UIKit

final class LoginCoordinator: Coordinatable {
    var flowCompletionHandler: (() -> Void)?

//    weak var parentCoordinator: Coordinatable?

    private(set) var childCoordinators: [Coordinatable] = []
    var navigationController: UINavigationController
    private(set) var vm: LoginViewModel

    init(vc: UINavigationController, vm: LoginViewModel) {
        self.navigationController = vc
        self.vm = vm
    }
    deinit {
        print("LoginCoordinator deinit")
    }

    func start() {
        vm.coordinator = self
        let loginViewController = LoginViewController(viewModel: vm)
        navigationController.setViewControllers([loginViewController], animated: false)
    }

    func pushToHome() {

        self.flowCompletionHandler?()


//        if let appCoordinator = parentCoordinator as? AppCoordinator {
//            self.vc.navigationBar.isHidden = true
//            vc.setViewControllers([appCoordinator.goHome()], animated: false)
//        }

    }


    func addChildCoordinator(_ coordinator: Coordinatable) {
        guard !childCoordinators.contains(where: { $0 === coordinator }) else {
            return
        }
        childCoordinators.append(coordinator)
    }

    func removeChildCoordinator(_ coordinator: Coordinatable) {
        childCoordinators = childCoordinators.filter { $0 === coordinator }
    }


}
