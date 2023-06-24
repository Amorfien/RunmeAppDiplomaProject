//
//  LoginViewModel.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 22.06.2023.
//

import Foundation

protocol LoginViewModelProtocol: AnyObject {
    var onStateDidChange: ((LoginViewModel.State) -> Void)? { get set }
    func updateState(viewInput: LoginViewModel.ViewInput)
}

final class LoginViewModel: LoginViewModelProtocol {

    enum State {
        case initial
//        case phone
//        case sms
//        case registration
        case error(Error)
    }

    enum ViewInput {
        case helloButtonDidTap
        case phoneButtonDidTap
        case smsButtonDidTap
        case registerButtonDidTap
    }

    weak var coordinator: LoginCoordinator?
    var onStateDidChange: ((State) -> Void)?

    private(set) var state: State = .initial {
        didSet {
            onStateDidChange?(state)
        }
    }

    deinit {
        print(#function, " LoginViewModel ⚙️")
    }

//    private let networkService: NetworkServiceProtocol
//
//    init(networkService: NetworkServiceProtocol) {
//        self.networkService = networkService
//    }

    func updateState(viewInput: ViewInput) {
        switch viewInput {
        case .helloButtonDidTap:
//            coordinator?.pushToHome()
            coordinator?.pushPhoneViewController()

        case .phoneButtonDidTap:
            coordinator?.pushOTPViewController()
        case .smsButtonDidTap:
            AuthManager.shared.searchUserInDb { [weak self] success in
                success ? self?.coordinator?.pushToHome() : self?.coordinator?.pushRegistrationViewController()
            }
        case .registerButtonDidTap:
            coordinator?.pushToHome()
        }
    }
    
}

