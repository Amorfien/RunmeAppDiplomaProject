//
//  LoginCoordinator.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 22.06.2023.
//

import UIKit

final class LoginCoordinator: Coordinatable {
    var flowCompletionHandler: (() -> Void)?

    private(set) var childCoordinators: [Coordinatable] = []
    var navigationController: UINavigationController
    private(set) var vm: LoginViewModel

    init(vc: UINavigationController, vm: LoginViewModel) {
        self.navigationController = vc
        self.vm = vm
    }
    deinit {
        print("LoginCoordinator deinit")
    }

    func start() {
        vm.coordinator = self
        let helloViewController = HelloViewController(viewModel: vm)
        navigationController.setViewControllers([helloViewController], animated: false)
    }

    func pushToHome() {

        self.flowCompletionHandler?()

    }

    func pushPhoneViewController() {
        let phoneViewController = PhoneViewController()
        phoneViewController.coordinator = self
        navigationController.pushViewController(phoneViewController, animated: true)
    }

    func pushOTPViewController() {
        let otpViewController = OTPViewController()
        otpViewController.coordinator = self
        navigationController.pushViewController(otpViewController, animated: true)
    }

    func pushRegistrationViewController() {
        let registrationViewController = RegistrationViewController()
        registrationViewController.coordinator = self
        navigationController.pushViewController(registrationViewController, animated: true)
    }

}
