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
        case identifiedUser
        case noUser
        case okay
        case error(Error)
    }

    enum ViewInput {
        case helloButtonDidTap
        case loginWithBio
        case phoneButtonDidTap
        case smsButtonDidTap
        case registerButtonDidTap(Runner)
    }

    private let localAuthorizationService: LocalAuthorizationService
    weak var coordinator: LoginCoordinator?
    var onStateDidChange: ((State) -> Void)?

    private(set) var state: State = .noUser {
        didSet {
            onStateDidChange?(state)
        }
    }

    init(localAuthorizationService: LocalAuthorizationService) {
        self.localAuthorizationService = localAuthorizationService
//        print(localAuthorizationService.sensorType)
    }

    deinit {
        print(#function, " LoginViewModel ⚙️")
    }

    /// дополнительный метод для того чтобы сработал didSet после инициализатора
    func initialState(completion: (_ sensorType: String, _ userPhone: String) -> Void) {
        ///только локальная проверка, в базе может не быть полной модели юзера
        if AuthManager.shared.currentUser != nil {
            self.state = .identifiedUser
        } else {
            self.state = .noUser
        }
        let sensorType = localAuthorizationService.sensorType
        let userPhone = AuthManager.shared.currentUser?.phoneNumber

        completion(sensorType, phoneFormatter(number: userPhone))

    }

    func updateState(viewInput: ViewInput) {
        switch viewInput {
        case .helloButtonDidTap:
//            coordinator?.pushPhoneViewController()
//            coordinator?.pushRegistrationViewController()
            coordinator?.pushToMain()

        case .loginWithBio:
            localAuthorizationService.authorizeIfPossible { [weak self] bioResult in
                if bioResult {
                    print("🟢")
                    self?.state = .okay
                    sleep(1)
                    self?.checkFullRegistration()
                } else {
                    print("⛔️")
                    //                     self?.state = .noBiometry
                }
            }
            
        case .phoneButtonDidTap:
            coordinator?.pushOTPViewController()

        case .smsButtonDidTap:
            checkFullRegistration()
            
        case .registerButtonDidTap(var runner):

//            let semaphore = DispatchSemaphore(value: 1)
            //не получилось реализовать семафор. Оставил вложенность.

            FirebaseStorageService.shared.upload(currentUserId: runner.id, photo: runner.avatar!) { result in
                switch result {

                case .success(let url):
                    print("Avatar upload")
                    runner.avatarURL = url.absoluteString

                    DatabaseService.shared.setUser(user: runner) { [weak self] result in
                        switch result {

                        case .success(_):
                            print("Success Register user \(runner.name ?? "")!!")
                            self?.coordinator?.pushToMain()
                        case .failure(let error):
                            print("Set User Error \(error.localizedDescription)")
                        }
                    }

                case .failure(let error):
                    print("Upload Error \(error.localizedDescription)")
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

