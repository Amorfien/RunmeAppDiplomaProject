//
//  LoginViewModel.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 22.06.2023.
//

import Foundation

protocol LoginViewModelProtocol: ViewModelProtocol {
    var onStateDidChange: ((LoginViewModel.State) -> Void)? { get set }
    func updateState(viewInput: LoginViewModel.ViewInput)
}

final class LoginViewModel: LoginViewModelProtocol {

    enum State {
        case identifiedUser(sensorType: String?, userPhone: String)
        case noUser
        case fastLogin
        case settings(Runner)
    }

    enum ViewInput {
        case initial
        case helloButtonDidTap
        case loginWithBio
        case phoneButtonDidTap(String)
        case termsButtonDidTap
        case smsButtonDidTap(String)
        case registerOrSettings
        case registerButtonDidTap(Runner)
    }

    private let localAuthorizationService: LocalAuthorizationService?
    private let userSettings: Runner?
    weak var coordinator: LoginCoordinator?
    var onStateDidChange: ((State) -> Void)?

    private(set) var state: State = .noUser {
        didSet {
            onStateDidChange?(state)
        }
    }

    // MARK: - Init
    init(localAuthorizationService: LocalAuthorizationService? = nil, userSettings: Runner? = nil) {
        self.localAuthorizationService = localAuthorizationService
        self.userSettings = userSettings
    }

    deinit {
        print(#function, " LoginViewModel ⚙️")
    }

    func updateState(viewInput: ViewInput) {
        switch viewInput {
        case .initial:
            if AuthManager.shared.currentUser != nil {
                let sensorType = localAuthorizationService?.sensorType
                let userPhone = AuthManager.shared.currentUser?.phoneNumber
                let formatedPhone = phoneFormatter(number: userPhone)
                self.state = .identifiedUser(sensorType: sensorType, userPhone: formatedPhone)
            } else {
                self.state = .noUser
            }
        case .helloButtonDidTap:
            coordinator?.pushPhoneViewController()
        case .loginWithBio:
            localAuthorizationService?.authorizeIfPossible { [weak self] bioResult in
                if bioResult {
                    print("🟢")
                    self?.state = .fastLogin
                    self?.checkFullRegistration()
                } else {
                    print("⛔️")
                }
            }
        case .phoneButtonDidTap(let text):
            AuthManager.shared.startAuth(phoneNumber: text) { [weak self] result in
                switch result {
                case .success(_):
                    self?.coordinator?.pushOTPViewController()
                case .failure(let phoneError):
                    self?.coordinator?.showErrorAlert(phoneError, handler: { })
                }
            }
        case .termsButtonDidTap:
            coordinator?.pushTermsViewController()
        case .smsButtonDidTap(let code):
            AuthManager.shared.verifyCode(smsCode: code) { [weak self] result in
                switch result {
                case .success(_):
                    self?.checkFullRegistration()
                case .failure(let smsError):
                    self?.coordinator?.showErrorAlert(smsError, handler: { })
                }
            }
        case .registerOrSettings:
            if let userSettings {
                self.state = .settings(userSettings)
            }
        case .registerButtonDidTap(let runner):

            FirebaseStorageService.shared.upload(currentUserId: runner.id, photo: runner.avatar!) { [weak self] result in
                switch result {

                case .success(let url):
                    print("Avatar upload ", url) //Прямая ссылка на аватар
                    DatabaseService.shared.setUser(user: runner) { [weak self] dbresult in
                        switch dbresult {
                        case .success(_):
                            print("Success Register user \(runner.name ?? "")!!")
                            self?.coordinator?.pushToMain()
                        case .failure(let error):
                            print("Set User Error \(error.localizedDescription)")
                            self?.coordinator?.showErrorAlert(error, handler: { })
                        }
                    }
                case .failure(let error):
                    print("Upload Error \(error.localizedDescription)")
                    self?.coordinator?.showErrorAlert(error, handler: { })
                }
            }
        }
    }

    private func checkFullRegistration() {
        DatabaseService.shared.searchUserInDb(userId: AuthManager.shared.currentUser?.uid ?? "---") { [weak self] success in
            DispatchQueue.main.async {
                success ? self?.coordinator?.pushToMain() : self?.coordinator?.pushRegistrationViewController()
            }
        }
    }

}

