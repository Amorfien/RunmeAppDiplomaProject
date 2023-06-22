//
//  FavoriteCoordinator.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 22.06.2023.
//

import UIKit

final class FavoriteCoordinator: Coordinatable {

    var childCoordinators: [Coordinatable] = []
    private(set) var vc: UINavigationController?
    private(set) var vm: LoginViewModelProtocol?///

    func start() -> UIViewController {
        let favoriteViewController = FavoriteViewController()
        favoriteViewController.tabBarItem = UITabBarItem(title: "Favorite", image: .remove, tag: 2)
        return favoriteViewController
    }

}
