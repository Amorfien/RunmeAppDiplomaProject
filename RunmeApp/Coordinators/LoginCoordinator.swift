//
//  LoginCoordinator.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 22.06.2023.
//

import UIKit

final class LoginCoordinator: Coordinatable {

    weak var parentCoordinator: Coordinatable?

    private(set) var childCoordinators: [Coordinatable] = []
    private(set) var vc: UINavigationController
    private(set) var vm: LoginViewModelProtocol

    init(vc: UINavigationController, vm: LoginViewModelProtocol) {
        self.vc = vc
        self.vm = vm
    }
    deinit {
        print("LoginCoordinator deinit")
    }

    func start() -> UIViewController {
        let loginViewModel = LoginViewModel()
        loginViewModel.coordinator = self
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        vc.viewControllers = [loginViewController]
        return vc
    }

    func pushToHome() {

        if let appCoordinator = parentCoordinator as? AppCoordinator {
            self.vc.navigationBar.isHidden = true
            vc.setViewControllers([appCoordinator.goHome()], animated: false)
        }

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
