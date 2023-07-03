//
//  FavoriteCoordinator.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 22.06.2023.
//

import UIKit

final class FavoriteCoordinator: Coordinatable {
    var flowCompletionHandler: ((Runner?) -> Void)?

    var childCoordinators: [Coordinatable] = []
    var navigationController: UINavigationController
    private(set) var vm: FavoriteViewModel

    init(vc: UINavigationController, vm: FavoriteViewModel) {
        self.navigationController = vc
        self.vm = vm
    }
    deinit {
        print("FavoriteCoordinator deinit")
    }

    func start() {
        vm.coordinator = self
        let favoriteViewController = FavoriteViewController(viewModel: vm)
        favoriteViewController.tabBarItem = UITabBarItem(title: "Избранное", image: UIImage(systemName: "heart"), tag: 2)
        navigationController.setViewControllers([favoriteViewController], animated: true)
    }

}
