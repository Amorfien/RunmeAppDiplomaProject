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

    func pushToMain() {

        self.flowCompletionHandler?()

    }

    func pushPhoneViewController() {
        let phoneViewController = PhoneVerificationViewController(viewModel: vm, type: .phone)
        navigationController.pushViewController(phoneViewController, animated: true)
    }
    func pushTermsViewController() {
        let termsViewController = TermsViewController()
        navigationController.pushViewController(termsViewController, animated: true)
    }

    func pushOTPViewController() {
        let otpViewController = PhoneVerificationViewController(viewModel: vm, type: .sms)
        navigationController.pushViewController(otpViewController, animated: true)
    }

    func pushRegistrationViewController() {
        let registrationViewController = RegistrationViewController(viewModel: vm)
        navigationController.pushViewController(registrationViewController, animated: true)
    }

//    func showErrorAlert(_ error: Error) {
//        DispatchQueue.main.async {
//            self.navigationController.showAlert(title: "Ошибка!", message: error.localizedDescription) {}
//        }
//    }

}
