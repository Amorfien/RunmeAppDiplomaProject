//
//  HomeCoordinator.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 22.06.2023.
//

import UIKit

final class HomeCoordinator: Coordinatable {
    
    var flowCompletionHandler: (() -> Void)?

    var childCoordinators: [Coordinatable] = []
    var navigationController: UINavigationController
    private(set) var vm: HomeViewModel

    init(vc: UINavigationController, vm: HomeViewModel) {
        self.navigationController = vc
        self.vm = vm
    }
    deinit {
        print("HomeCoordinator deinit")
    }

    func start() {
        vm.coordinator = self
        let homeViewController = HomeViewController(viewModel: vm)
        homeViewController.tabBarItem = UITabBarItem(title: "Главная", image: UIImage(systemName: "house"), tag: 0)
        navigationController.setViewControllers([homeViewController], animated: true)
    }

    func presentSheetPresentationController(user: Runner) {
//        let profileVC = ProfileViewController(viewModel: nil, profile: user)
        let vm = ProfileViewModel(userId: user.id)
        let profileVC = ProfileViewController(viewModel: vm)
        profileVC.view.alpha = 0.97

        if let sheet = profileVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
        }

        navigationController.present(profileVC, animated: true)
    }

}
