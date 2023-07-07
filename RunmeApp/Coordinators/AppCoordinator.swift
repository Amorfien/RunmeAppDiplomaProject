//
//  AppCoordinator.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 22.06.2023.
//

import UIKit
import FirebaseAuth

final class AppCoordinator: Coordinatable {
    
    var flowCompletionHandler: ((Runner?) -> Void)?

    private(set) var childCoordinators: [Coordinatable] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    deinit {
        print("AppCoordinator deinit")
    }

    func start() {
        goToLogin()
    }

    private func goToLogin() {
        childCoordinators.removeAll()
        let localAuthorizationService = LocalAuthorizationService()
        let loginViewModel = LoginViewModel(localAuthorizationService: localAuthorizationService)
        let loginCoordinator = LoginCoordinator(vc: navigationController, vm: loginViewModel)
        addChildCoordinator(loginCoordinator)

        loginCoordinator.flowCompletionHandler = { [weak self] _ in ///maybe
            self?.goToMain()
        }
        loginCoordinator.start()
    }

    private func goToMain() {
        childCoordinators.removeAll()

        let newsService = NewsService()
        let homeViewModel = HomeViewModel(newsService: newsService)
        let homeCoordinator = HomeCoordinator(vc: UINavigationController(), vm: homeViewModel)
        homeCoordinator.flowCompletionHandler = { [weak self] runner in
            self?.presentSheetPresentationController(user: runner!)
        }

        let profileViewModel = ProfileViewModel(userId: AuthManager.shared.currentUser!.uid) ////// !!!!!!!
        let profileCoordinator = ProfileCoordinator(vc: UINavigationController(), vm: profileViewModel)
        profileCoordinator.flowCompletionHandler = { [weak self] _ in
            self?.goToLogin()
        }

        let favoriteViewModel = FavoriteViewModel()
        let favoriteCoordinator = FavoriteCoordinator(vc: UINavigationController(), vm: favoriteViewModel)

        let resultsViewModl = ResultsViewModel()
        let resultsCoordinator = ResultsCoordinator(vc: UINavigationController(), vm: resultsViewModl)
        resultsCoordinator.flowCompletionHandler = { [weak self] runner in
            self?.presentSheetPresentationController(user: runner!)
        }

        let appTabBarController = AppTabBarController(viewControllers: [
            homeCoordinator.navigationController,
            profileCoordinator.navigationController,
            favoriteCoordinator.navigationController,
            resultsCoordinator.navigationController
        ])
        appTabBarController.selectedIndex = 1//______________________________

        homeCoordinator.start()
        profileCoordinator.start()
        favoriteCoordinator.start()
        resultsCoordinator.start()

        addChildCoordinator(homeCoordinator)
        addChildCoordinator(profileCoordinator)
        addChildCoordinator(favoriteCoordinator)
        addChildCoordinator(resultsCoordinator)

        navigationController.navigationBar.isHidden = true
        navigationController.setViewControllers([appTabBarController], animated: true)

    }

    private func presentSheetPresentationController(user: Runner) {
        let pvm = ProfileViewModel(userId: user.id)
        let profileVC = ProfileViewController(viewModel: pvm)
        profileVC.view.alpha = 0.97
        
        if let sheet = profileVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
        }
        
        navigationController.present(profileVC, animated: true)
    }




    func addChildCoordinator(_ coordinator: Coordinatable) {
        guard !childCoordinators.contains(where: { $0 === coordinator }) else {
            return
        }
        childCoordinators.append(coordinator)
    }

    func removeChildCoordinator(_ coordinator: Coordinatable) {
        childCoordinators = childCoordinators.filter { $0 === coordinator }
    }



}
