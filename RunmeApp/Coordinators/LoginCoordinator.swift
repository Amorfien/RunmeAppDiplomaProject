//
//  LoginCoordinator.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 22.06.2023.
//

import UIKit

final class LoginCoordinator: Coordinatable {

    private(set) var childCoordinators: [Coordinatable] = []
    private(set) var vc: UINavigationController
    private(set) var vm: LoginViewModelProtocol

    init(vc: UINavigationController, vm: LoginViewModelProtocol) {
        self.vc = vc
        self.vm = vm
    }

    func start() -> UIViewController {
        let loginViewModel = LoginViewModel()
        loginViewModel.coordinator = self
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        vc.viewControllers = [loginViewController]
        return vc
    }

    func pushToHome() {
        let homeCoordinator = HomeCoordinator()
        let profileCoordinator = ProfileCoordinator()
        let favoriteCoordinator = FavoriteCoordinator()

        let appTabBarController = AppTabBarController(viewControllers: [
            homeCoordinator.start(),
            profileCoordinator.start(),
            favoriteCoordinator.start()
        ])
            print(childCoordinators)
        removeChildCoordinator(self)
            print(childCoordinators)
        addChildCoordinator(homeCoordinator)
        addChildCoordinator(profileCoordinator)
        addChildCoordinator(favoriteCoordinator)
            print(childCoordinators)

        vc.setViewControllers([appTabBarController], animated: false)

//        print("login")
    }


}
