//
//  ResultsViewModel.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 02.07.2023.
//

import Foundation

protocol ResultsViewModelProtocol: ViewModelProtocol {
    var onStateDidChange: ((ResultsViewModel.State) -> Void)? { get set }
    func updateState(viewInput: ResultsViewModel.ViewInput)
}

final class ResultsViewModel: ResultsViewModelProtocol {

    enum State {
        case initial
        case loading
        case loadedResults([RunnersBests])
    }

    enum ViewInput {
        case needUpdate
        case changeDist(Int)
        case chooseUser(String)
    }

    
    weak var coordinator: ResultsCoordinator?

    var onStateDidChange: ((State) -> Void)?

    private(set) var state: State = .initial {
        didSet {
            onStateDidChange?(state)
        }
    }

    deinit {
        print(#function, " ResultsViewModel ⚙️")
    }

    func updateState(viewInput: ViewInput) {
        switch viewInput {
        case .needUpdate:
            DatabaseService.shared.getAllUsers { result in
                switch result {
                case .success(var bests):

                    bests.sort { lhs, rhs in
                        lhs.personalBests[0] < rhs.personalBests[0]
                    }
                    self.state = .loadedResults(bests)
                case .failure(_):
                    print("No results")
                }
            }
        case .changeDist(let index):
            print(index)
        case .chooseUser(let id):
            chooseUser(id: id)
        }
    }


    private func chooseUser(id: String) {
        DatabaseService.shared.getUser(userId: id) { [weak self] result in
            switch result {
            case .success(let user):
//                self?.coordinator?.presentSheetPresentationController(user: user)
                self?.coordinator?.flowCompletionHandler!(user)
            case .failure(let userError):
                print("Choose User Error, \(userError.localizedDescription)")
                self?.coordinator?.showErrorAlert(userError, handler: { })
            }
        }
    }


}

