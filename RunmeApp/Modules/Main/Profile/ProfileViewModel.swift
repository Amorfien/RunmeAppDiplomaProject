//
//  ProfileViewModel.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 23.06.2023.
//

import Foundation

protocol ProfileViewModelProtocol: ViewModelProtocol {
    var onStateDidChange: ((ProfileViewModel.State) -> Void)? { get set }
    func updateState(viewInput: ProfileViewModel.ViewInput)
}

final class ProfileViewModel: ProfileViewModelProtocol {

    weak var coordinator: ProfileCoordinator?
    
    enum State {
        case initial
//        case loading
        case loadedProfile(Runner)
        case loadedImageData(Data)
        case error(Error)
    }

    enum ViewInput {
        case showUser
        case logOut
    }

    var onStateDidChange: ((State) -> Void)?

    private(set) var state: State = .initial {
        didSet {
            onStateDidChange?(state)
        }
    }

    private let userId: String

    init(userId: String) {
        self.userId = userId
    }
    deinit {
        print(#function, " ProfileViewModel ⚙️")
    }

    func updateState(viewInput: ViewInput) {
        switch viewInput {
        case .showUser:
            DatabaseService.shared.getUser(userId: userId) { [weak self] dbResult in
                switch dbResult {
                case .success(let profile):
                    self?.state = .loadedProfile(profile)

                case .failure(_):
                    ()
                }
            }

            FirebaseStorageService.shared.downloadById(id: userId) { [weak self] imgResult in
                switch imgResult {
                case .success(let data):
                    self?.state = .loadedImageData(data)
                case .failure(_):
                    ()
                }
            }
        case .logOut:
            AuthManager.shared.signOut()
            coordinator?.logOut()
        }
    }
}
