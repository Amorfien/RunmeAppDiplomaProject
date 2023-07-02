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
        case loadedResults([String])
    }

    enum ViewInput {
        case changeDist(Int)
        case chooseUser(String)
    }

    
    weak var coordinator: ResultsCoordinator?

    var onStateDidChange: ((State) -> Void)?

    deinit {
        print(#function, " ResultsViewModel ⚙️")
    }

    func updateState(viewInput: ViewInput) {
        switch viewInput {
        case .changeDist(let index):
            print(index)
        case .chooseUser(_):
            ()
        }
    }


}

