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
        case registerButtonDidTap(Runner)
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

    func updateState(viewInput: ViewInput) {
        switch viewInput {
        case .helloButtonDidTap:
            coordinator?.pushPhoneViewController()
//            coordinator?.pushRegistrationViewController()
            
        case .phoneButtonDidTap:
            coordinator?.pushOTPViewController()

        case .smsButtonDidTap:
            DatabaseService.shared.searchUserInDb(userId: AuthManager.shared.currentUser?.uid ?? "---") { [weak self] success in
                DispatchQueue.main.async {
                    success ? self?.coordinator?.pushToMain() : self?.coordinator?.pushRegistrationViewController()
                }
            }
            
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
    
}

