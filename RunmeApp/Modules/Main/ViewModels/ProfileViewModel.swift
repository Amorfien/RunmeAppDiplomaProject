//
//  ProfileViewModel.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 23.06.2023.
//

import Foundation

protocol ProfileViewModelProtocol: AnyObject {
    var onStateDidChange: ((ProfileViewModel.State) -> Void)? { get set }
    func updateState(viewInput: ProfileViewModel.ViewInput)
}

final class ProfileViewModel: ProfileViewModelProtocol {

    enum State {
        case initial
//        case loading
//        case loaded
        case error(Error)
    }

    enum ViewInput {
        case logOut
    }

    weak var coordinator: ProfileCoordinator?
    var onStateDidChange: ((State) -> Void)?

    private(set) var state: State = .initial {
        didSet {
            onStateDidChange?(state)
        }
    }

    deinit {
        print(#function, " ProfileViewModel ⚙️")
    }

    func updateState(viewInput: ViewInput) {
        switch viewInput {
        case .logOut:
            AuthManager.shared.signOut()
            coordinator?.logOut()
        }
    }
}
