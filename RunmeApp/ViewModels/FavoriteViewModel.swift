//
//  FavoriteViewModel.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 23.06.2023.
//

import Foundation

protocol FavoriteViewModelProtocol: AnyObject {
    var onStateDidChange: ((FavoriteViewModel.State) -> Void)? { get set }
    func updateState(viewInput: FavoriteViewModel.ViewInput)
}

final class FavoriteViewModel: FavoriteViewModelProtocol {

    enum State {
        case initial
        case loading
        case loaded
        case error(Error)
    }

    enum ViewInput {
        case logOut
    }

    weak var coordinator: HomeCoordinator?
    var onStateDidChange: ((State) -> Void)?

    private(set) var state: State = .initial {
        didSet {
            onStateDidChange?(state)
        }
    }

    func updateState(viewInput: ViewInput) {
        switch viewInput {
        case .logOut:
            ()

        }
    }
}
