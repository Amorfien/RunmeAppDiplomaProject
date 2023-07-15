//
//  FavoriteViewModel.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 23.06.2023.
//

import Foundation

protocol FavoriteViewModelProtocol: ViewModelProtocol {
    var onStateDidChange: ((FavoriteViewModel.State) -> Void)? { get set }
    func updateState(viewInput: FavoriteViewModel.ViewInput)
}

final class FavoriteViewModel: FavoriteViewModelProtocol {

    enum State {
        case initial
        case favorite([Article])
//        case loading
//        case loaded
//        case error(Error)
    }

    enum ViewInput {
        case fetchFavorites(predicate: NSPredicate? = nil)
        case delete(url: String)
    }

    weak var coordinator: FavoriteCoordinator?
    var onStateDidChange: ((State) -> Void)?

    let coreDataService = CoreDataService()

    private(set) var state: State = .initial {
        didSet {
            onStateDidChange?(state)
        }
    }

    deinit {
        print(#function, " FavoriteViewModel ⚙️")
    }

    func updateState(viewInput: ViewInput) {
        switch viewInput {
        case .fetchFavorites(let predicate):


            let news = coreDataService.fetching(predicate: predicate)
//            self.favoritesPosts = posts.map { Post(postCoreDataModel: $0) }
            self.state = .favorite(news.map {Article(newsCoreDataModel: $0)})

        case .delete(url: let url):
            coreDataService.deletePost(predicate: NSPredicate(format: "url == %ld", url))


        }
    }
}
