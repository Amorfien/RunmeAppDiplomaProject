//
//  AppCoordinator.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 22.06.2023.
//

import UIKit

final class AppCoordinator: Coordinatable {
    var flowCompletionHandler: (() -> Void)?

    private var isLogin = false

    private(set) var childCoordinators: [Coordinatable] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    deinit {
        print("AppCoordinator deinit")
    }

    func goToLogin() {
        childCoordinators.removeAll()
        let loginViewModel = LoginViewModel()
        let loginCoordinator = LoginCoordinator(vc: navigationController, vm: loginViewModel)
        addChildCoordinator(loginCoordinator)

        loginCoordinator.flowCompletionHandler = { [ weak self ] in
            self?.isLogin = true
//            self?.removeChildCoordinator(loginCoordinator)
            self?.start()
        }
        loginCoordinator.start()
    }

    func start() {
        isLogin ? goMain() : goToLogin()
    }

    func goMain() {
        childCoordinators.removeAll()
        let homeViewModel = HomeViewModel()
        let homeCoordinator = HomeCoordinator(vc: UINavigationController(), vm: homeViewModel)

        let profileViewModel = ProfileViewModel()
        let profileCoordinator = ProfileCoordinator(vc: UINavigationController(), vm: profileViewModel)
        profileCoordinator.flowCompletionHandler = { [weak self] in
            self?.isLogin = false
            self?.start()
        }

        let favoriteViewModel = FavoriteViewModel()
        let favoriteCoordinator = FavoriteCoordinator(vc: UINavigationController(), vm: favoriteViewModel)

        let appTabBarController = AppTabBarController(viewControllers: [
            homeCoordinator.navigationController,
            profileCoordinator.navigationController,
            favoriteCoordinator.navigationController
        ])

        homeCoordinator.start()
        profileCoordinator.start()
        favoriteCoordinator.start()

        addChildCoordinator(homeCoordinator)
        addChildCoordinator(profileCoordinator)
        addChildCoordinator(favoriteCoordinator)

        navigationController.navigationBar.isHidden = true
        navigationController.setViewControllers([appTabBarController], animated: true)

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
