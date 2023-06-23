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
        case loading
        case loaded
        case error(Error)
    }

    enum ViewInput {
        case loadButtonDidTap
        case bookDidSelect
    }

    weak var coordinator: LoginCoordinator?
    var onStateDidChange: ((State) -> Void)?

    private(set) var state: State = .initial {
        didSet {
            onStateDidChange?(state)
        }
    }

    deinit {
        print(#function, " LoginViewModel")
    }

//    private let networkService: NetworkServiceProtocol
//
//    init(networkService: NetworkServiceProtocol) {
//        self.networkService = networkService
//    }

    func updateState(viewInput: ViewInput) {
        switch viewInput {
        case .loadButtonDidTap:
            coordinator?.pushToHome()

        case .bookDidSelect:
            ()
//            coordinator?.pushBookViewController(forBook: book)
        }
    }
    
}

