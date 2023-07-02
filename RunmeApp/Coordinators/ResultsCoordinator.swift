//
//  ResultsCoordinator.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 02.07.2023.
//

import UIKit

final class ResultsCoordinator: Coordinatable {
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinatable] = []
    private(set) var vm: ResultsViewModel
    
    var flowCompletionHandler: (() -> Void)?

    init(vc: UINavigationController, vm: ResultsViewModel) {
        self.navigationController = vc
        self.vm = vm
    }
    deinit {
        print("ResultsCoordinator deinit")
    }

    func start() {
        vm.coordinator = self
        let resultsViewController = ResultsViewController(viewModel: vm)
        resultsViewController.tabBarItem = UITabBarItem(title: "Результаты", image: UIImage(systemName: "list.bullet.rectangle"), tag: 3)
        navigationController.setViewControllers([resultsViewController], animated: true)
    }

    
}
