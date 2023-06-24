//
//  ProfileCoordinator.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 22.06.2023.
//

import UIKit

final class ProfileCoordinator: Coordinatable {

    var flowCompletionHandler: (() -> Void)?

    var childCoordinators: [Coordinatable] = []
    var navigationController: UINavigationController
    private(set) var vm: ProfileViewModel

    init(vc: UINavigationController, vm: ProfileViewModel) {
        self.navigationController = vc
        self.vm = vm
    }
    deinit {
        print("ProfileCoordinator deinit")
    }

    func start() {
        vm.coordinator = self
        let profileViewController = ProfileViewController(viewModel: vm)
        profileViewController.tabBarItem = UITabBarItem(title: "Profile", image: .actions, tag: 1)
        navigationController.setViewControllers([profileViewController], animated: true)
    }

    func logOut() {

        AuthManager.shared.signOut()

        self.flowCompletionHandler?()

    }

}
