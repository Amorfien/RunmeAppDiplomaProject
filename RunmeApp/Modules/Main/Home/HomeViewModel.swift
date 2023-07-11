//
//  HomeViewModel.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 23.06.2023.
//

import Foundation

protocol HomeViewModelProtocol: ViewModelProtocol {
    var onStateDidChange: ((HomeViewModel.State) -> Void)? { get set }
    func updateState(viewInput: HomeViewModel.ViewInput)
}

final class HomeViewModel: HomeViewModelProtocol {

    enum State {
        case initial
        case loading
        case loadedAvatars([String: Data])
        case loadedNews([Article])
        case loadedPosts([RunnerPost])
        case likePost(RunnerPost)
//        case error(Error)
    }

    enum ViewInput {
        case runnersSegment
        case newsSegment
        case chooseUser(String)
        case likeDidTap(String)
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
        case .runnersSegment:
            self.state = .loading

            getAllAvatars()

            getAllPosts()

        case .newsSegment:
            self.state = .loading

            getAllNews()
        case .chooseUser(let id):
            chooseUser(id: id)
        case .likeDidTap(let id):
            DatabaseService.shared.fetchPost(postIdd: id) { fetchPostResult in
                switch fetchPostResult {

                case .success(var post):
                    guard let itsme = AuthManager.shared.currentUser?.uid else { return }
                    guard !post.likes.contains(itsme), post.userId != itsme else { return }
                    post.likes.append(itsme)
                    DatabaseService.shared.updatePost(post: post) { updPostResult in
                        switch updPostResult {
                        case .success(let updPost):
                            self.state = .likePost(updPost)
                        case .failure(_):
                            print("Fail update post")
                        }
                    }
                case .failure(_):
                    print("Fail fetch post")
                }
            }
        }
    }

    ///достать новости
    private func getAllNews() {
        newsService.loadNews { [weak self] result in
            switch result {
            case .success(let news):
//                print(news.count)
//                sleep(1)
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
                sleep(1)
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
//        DatabaseService.shared.getUser(userId: id) { [weak self] result in
//            switch result {
//            case .success(let user):
////                self?.coordinator?.presentSheetPresentationController(user: user)
//                self?.coordinator?.flowCompletionHandler!(user)
//            case .failure(let userError):
//                print("Choose User Error, \(userError.localizedDescription)")
//                self?.coordinator?.showErrorAlert(userError, handler: { })
//            }
//        }
    }

    private func getAllPosts() {
        DatabaseService.shared.getAllPosts { [weak self] postsResult in
            switch postsResult {

            case .success(let posts):
                sleep(1)
                self?.state = .loadedPosts(posts.sorted())
            case .failure(let postsError):
                print(postsError.localizedDescription)
            }
        }
    }




}
