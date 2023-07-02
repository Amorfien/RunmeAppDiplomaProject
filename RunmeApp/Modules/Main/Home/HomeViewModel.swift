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
        case loadedNews([Article])
        case loadedAvatars([String: Data])
//        case error(Error)
    }

    enum ViewInput {
        case forYouSegment
        case newsSegment
        case chooseUser(String)
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

            getAllAvatars()

            ///заглушка чтобы не расходывать трафик/запросы
            let news: [Article] = [testNews1, testNews2, testNews2, testNews2, testNews1, testNews2]
            self.state = .loadedNews(news)

        case .newsSegment:
            self.state = .loading

            getAllNews()
        case .chooseUser(let id):
            chooseUser(id: id)
        }
    }

    ///достать новости
    private func getAllNews() {
        newsService.loadNews { [weak self] result in
            switch result {
            case .success(let news):
                print(news.count)
                self?.state = .loadedNews(news)
            case .failure(let newsError):
                print(newsError.localizedDescription)
                self?.coordinator?.showErrorAlert(newsError, handler: {
                    self?.state = .initial
                })
//                self?.state = .error(error)
            }
        }
    }

    ///достать аватары юзеров
    private func getAllAvatars() {
        FirebaseStorageService.shared.downloadAllAvatars { [weak self] result in
            switch result {
            case .success(let dict):
                self?.state = .loadedAvatars(dict)
            case .failure(let avatarsError):
                print("Download avatars Error, \(avatarsError.localizedDescription)")
                self?.coordinator?.showErrorAlert(avatarsError, handler: {
                    self?.state = .initial
                })
            }
        }
    }

    private func chooseUser(id: String) {
        DatabaseService.shared.getUser(userId: id) { [weak self] result in
            switch result {
            case .success(let user):
                self?.coordinator?.presentSheetPresentationController(user: user)
            case .failure(let userError):
                print("Choose User Error, \(userError.localizedDescription)")
                self?.coordinator?.showErrorAlert(userError, handler: { })
            }
        }
    }




}
