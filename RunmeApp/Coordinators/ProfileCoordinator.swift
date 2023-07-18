//
//  ProfileCoordinator.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 22.06.2023.
//

import UIKit

final class ProfileCoordinator: Coordinatable {

    var flowCompletionHandler: ((Runner?) -> Void)?

    var childCoordinators: [Coordinatable] = []
    var navigationController: UINavigationController
    private(set) var vm: ProfileViewModel

    private let profileViewController: ProfileViewController

    init(vc: UINavigationController, vm: ProfileViewModel) {
        self.navigationController = vc
        self.vm = vm
        profileViewController = ProfileViewController(viewModel: vm, isEditable: true)
    }
    deinit {
        print("ProfileCoordinator deinit")
    }

    func start() {
        vm.coordinator = self
        let slideMenuViewController = SlideMenuViewController()
        slideMenuViewController.delegate = profileViewController
        let containerVC = ContainerViewController(profileVC: profileViewController, menuVC: slideMenuViewController)
        containerVC.tabBarItem = UITabBarItem(title: "Профиль".localized, image: UIImage(systemName: "person.crop.rectangle"), tag: 1)
        navigationController.viewControllers = [containerVC]
    }

    func logOut() {
        self.flowCompletionHandler?(nil)
    }

    func showSettings(userSettings: Runner?) {
        let settingsViewController = SettingsViewController(viewModel: vm)
        settingsViewController.delegate = profileViewController
        navigationController.present(settingsViewController, animated: true)
    }

}
