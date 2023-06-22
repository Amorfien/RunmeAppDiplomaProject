//
//  ProfileCoordinator.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 22.06.2023.
//

import UIKit

final class ProfileCoordinator: Coordinatable {

    var childCoordinators: [Coordinatable] = []
    private(set) var vc: UINavigationController?
    private(set) var vm: LoginViewModelProtocol?///

    func start() -> UIViewController {
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(title: "Profile", image: .actions, tag: 1)
        return profileViewController
    }

}
