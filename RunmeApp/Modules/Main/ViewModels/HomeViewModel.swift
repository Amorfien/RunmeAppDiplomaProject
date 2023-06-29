//
//  HomeViewModel.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 23.06.2023.
//

import Foundation

protocol HomeViewModelProtocol: AnyObject {
    var onStateDidChange: ((HomeViewModel.State) -> Void)? { get set }
    func updateState(viewInput: HomeViewModel.ViewInput)
}

final class HomeViewModel: HomeViewModelProtocol {

    enum State {
        case initial
        case loading
        case loaded([Article])
        case error(Error)
    }

    enum ViewInput {
        case forYouSegment
        case newsSegment
    }

    private let newsService: NewsService

    weak var coordinator: HomeCoordinator?
    var onStateDidChange: ((State) -> Void)?

    private(set) var state: State = .initial {
        didSet {
            onStateDidChange?(state)
        }
    }

    init(newsService: NewsService) {
        self.newsService = newsService
    }
    deinit {
        print(#function, " HomeViewModel ⚙️")
    }

    func updateState(viewInput: ViewInput) {
        switch viewInput {
        case .forYouSegment:
            self.state = .loading

            ///заглушка чтобы не расходывать трафик/запросы
            let news: [Article] = [testNews1, testNews2, testNews2, testNews2, testNews1, testNews2]
            self.state = .loaded(news)

        case .newsSegment:
            self.state = .loading
            newsService.loadNews { result in
                switch result {
                case .success(let news):
                    print(news.count)
                    self.state = .loaded(news)
                case .failure(let error):
                    print(error.localizedDescription)
                    self.state = .error(error)
                }
            }
        }
    }


    ///достать аватары юзеров
    func getAllAvatars(completion: @escaping ([Data]) -> Void) {




    }




}
