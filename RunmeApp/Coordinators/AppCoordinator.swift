//
//  AppCoordinator.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 22.06.2023.
//

import UIKit

final class AppCoordinator: Coordinatable {
    private(set) var childCoordinators: [Coordinatable] = []

    private var isLogin: Bool = false

    init(isLogin: Bool) {
        self.isLogin = isLogin
    }

    func start() -> UIViewController {

        if isLogin {

            let homeCoordinator = HomeCoordinator()
            let profileCoordinator = ProfileCoordinator()
            let favoriteCoordinator = FavoriteCoordinator()
            
            let appTabBarController = AppTabBarController(viewControllers: [
                homeCoordinator.start(),
                profileCoordinator.start(),
                favoriteCoordinator.start()
            ])

            addChildCoordinator(homeCoordinator)
            addChildCoordinator(profileCoordinator)
            addChildCoordinator(favoriteCoordinator)

            return appTabBarController

        } else {

            let loginCoordinator = LoginCoordinator(vc: UINavigationController(), vm: LoginViewModel())
            addChildCoordinator(loginCoordinator)
            return loginCoordinator.start()

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
