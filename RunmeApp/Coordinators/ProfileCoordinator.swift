//
//  ProfileCoordinator.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 22.06.2023.
//

import UIKit

final class ProfileCoordinator: Coordinatable {

    weak var parentCoordinator: Coordinatable?

    var childCoordinators: [Coordinatable] = []
    private(set) var vc: UINavigationController
    private(set) var vm: ProfileViewModelProtocol

    init(vc: UINavigationController, vm: ProfileViewModelProtocol) {
        self.vc = vc
        self.vm = vm
    }
    deinit {
        print("ProfileCoordinator deinit")
    }

    func start() -> UIViewController {
        let profileViewModel = ProfileViewModel()
        let profileViewController = ProfileViewController(viewModel: profileViewModel)
        profileViewController.tabBarItem = UITabBarItem(title: "Profile", image: .actions, tag: 1)
        vc.viewControllers = [profileViewController]
        return vc
    }

    func logOut() {
        if let appCoordinator = parentCoordinator as? AppCoordinator {
            vc.setViewControllers([appCoordinator.goHome()], animated: false)
        }
    }

}
