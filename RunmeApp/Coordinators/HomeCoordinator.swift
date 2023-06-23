//
//  HomeCoordinator.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 22.06.2023.
//

import UIKit

final class HomeCoordinator: Coordinatable {

    weak var parentCoordinator: Coordinatable?

    var childCoordinators: [Coordinatable] = []
    private(set) var vc: UINavigationController
    private(set) var vm: HomeViewModelProtocol

    init(vc: UINavigationController, vm: HomeViewModelProtocol) {
        self.vc = vc
        self.vm = vm
    }
    deinit {
        print("HomeCoordinator deinit")
    }

    func start() -> UIViewController {
        let homeViewController = HomeViewController()
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: .add, tag: 0)
        vc.viewControllers = [homeViewController]
        return vc
    }

}
