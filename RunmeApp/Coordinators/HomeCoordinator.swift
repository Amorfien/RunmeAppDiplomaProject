//
//  HomeCoordinator.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 22.06.2023.
//

import UIKit

final class HomeCoordinator: Coordinatable {
    
    var flowCompletionHandler: ((Runner?) -> Void)?

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
        homeViewController.tabBarItem = UITabBarItem(title: "Главная".localized, image: UIImage(systemName: "house"), tag: 0)
        navigationController.setViewControllers([homeViewController], animated: true)
    }


}
