//
//  HomeCoordinator.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 22.06.2023.
//

import UIKit

final class HomeCoordinator: Coordinatable {

    var childCoordinators: [Coordinatable] = []
    private(set) var vc: UINavigationController?
    private(set) var vm: LoginViewModelProtocol?///

    func start() -> UIViewController {
        let homeViewController = HomeViewController()
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: .add, tag: 0)
        return homeViewController
    }

}
