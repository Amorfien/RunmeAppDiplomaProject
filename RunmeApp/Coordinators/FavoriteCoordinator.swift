//
//  FavoriteCoordinator.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 22.06.2023.
//

import UIKit

final class FavoriteCoordinator: Coordinatable {

    weak var parentCoordinator: Coordinatable?

    var childCoordinators: [Coordinatable] = []
    private(set) var vc: UINavigationController
    private(set) var vm: FavoriteViewModelProtocol

    init(vc: UINavigationController, vm: FavoriteViewModelProtocol) {
        self.vc = vc
        self.vm = vm
    }
    deinit {
        print("FavoriteCoordinator deinit")
    }

    func start() -> UIViewController {
        let favoriteViewController = FavoriteViewController()
        favoriteViewController.tabBarItem = UITabBarItem(title: "Favorite", image: .remove, tag: 2)
        vc.viewControllers = [favoriteViewController]
        return vc
    }

}
