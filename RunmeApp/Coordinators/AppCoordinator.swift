//
//  AppCoordinator.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 22.06.2023.
//

import UIKit

final class AppCoordinator: AppCoordinatorProtocol {
    var parentCoordinator: Coordinatable?
    private(set) var childCoordinators: [Coordinatable] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    deinit {
        print("AppCoordinator deinit")
    }

    func goToLogin() -> UIViewController {
        childCoordinators.removeAll()
        let loginViewModel = LoginViewModel()
        let loginCoordinator = LoginCoordinator(vc: navigationController, vm: loginViewModel)
        loginCoordinator.parentCoordinator = self
        addChildCoordinator(loginCoordinator)
        return loginCoordinator.start()
    }
    func goHome() -> UIViewController {
        childCoordinators.removeAll()
        let homeViewModel = HomeViewModel()
        let homeCoordinator = HomeCoordinator(vc: UINavigationController(), vm: homeViewModel)

        let profileViewModel = ProfileViewModel()
        let profileCoordinator = ProfileCoordinator(vc: UINavigationController(), vm: profileViewModel)
        profileCoordinator.parentCoordinator = self
        
        let favoriteViewModel = FavoriteViewModel()
        let favoriteCoordinator = FavoriteCoordinator(vc: UINavigationController(), vm: favoriteViewModel)

        let appTabBarController = AppTabBarController(viewControllers: [
            homeCoordinator.start(),
            profileCoordinator.start(),
            favoriteCoordinator.start()
        ])

        addChildCoordinator(homeCoordinator)
        addChildCoordinator(profileCoordinator)
        addChildCoordinator(favoriteCoordinator)

        return appTabBarController
    }

    func start() -> UIViewController {
        UIViewController()
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
