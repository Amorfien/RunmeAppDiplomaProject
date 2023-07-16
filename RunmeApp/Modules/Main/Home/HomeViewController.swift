//
//  HomeViewController.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 22.06.2023.
//

import UIKit

final class HomeViewController: UIViewController {

    // MARK: - Properties

    private let viewModel: HomeViewModel

    var articles: [Article] = [] {
        didSet {
//            print(articles)
            self.newsTableView.reloadData()
        }
    }
    var runnerPosts: [RunnerPost] = []
    var selectedRunner: [RunnerPost] = [] {
        didSet {
            self.newsTableView.reloadData()
        }
    }
    var avatarsDict: [String: UIImage] = [:] {
        didSet {
            self.newsTableView.reloadData()
        }
    }
    private var choosenUserId = "0" //храним выбранного юзера для правильного обновления в случае лайка
    private var selectedPostRow: IndexPath? = nil

    private lazy var sourceSegment: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Для вас", "Новости"])
        segmentedControl.selectedSegmentTintColor = .tintColor
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(changeSource), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()

    private let tableHeaderView = FriendCardsCollectionView()

    private let activityIndicator = UIActivityIndicatorView(style: .large)

    private lazy var newsTableView: UITableView = {
        let tableView = UITableView()
        tableView.tableHeaderView = tableHeaderView
        tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 120)
        tableView.register(RunnerPostTableViewCell.self, forCellReuseIdentifier: RunnerPostTableViewCell.reuseId)
        tableView.register(NewsPostTableViewCell.self, forCellReuseIdentifier: NewsPostTableViewCell.reuseId)
        tableView.register(HeaderInSectionView.self, forHeaderFooterViewReuseIdentifier: HeaderInSectionView.reuseId)
        tableView.sectionFooterHeight = 0
        tableView.sectionHeaderTopPadding = 0
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    //MARK: - Init

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print(#function, " HomeViewController 📱")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupView()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.updateState(viewInput: .runnersSegment)
    }

    // MARK: - Setup view

    private func setupNavigation() {
        navigationItem.title = "Участники"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.titleView = sourceSegment
        sourceSegment.widthAnchor.constraint(equalToConstant: 240).isActive = true
    }

    private func setupView() {
        tableHeaderView.headerDelegate = self
        view.backgroundColor = Res.PRColors.prLight
        view.addSubview(newsTableView)
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            newsTableView.topAnchor.constraint(equalTo: view.topAnchor),
            newsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            newsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100)
        ])
    }

    // MARK: - ViewModel Binding
    
    private func bindViewModel() {
        viewModel.onStateDidChange = { [weak self] state in
            guard let self = self else {
                return
            }
            switch state {
            case .initial:
                updateTableViewVisibility(isHidden: true)
                updateLoadingAnimation(isLoading: false)
            case .loading:
                updateTableViewVisibility(isHidden: true)
                updateLoadingAnimation(isLoading: true)
            case .loadedAvatars(let dict):
                var users: [String] = []
                var images: [UIImage] = []
                for (user, data) in dict {
                    users.append(user)
                    images.append(UIImage(data: data) ?? UIImage(named: "dafault-avatar")!)
                }
                avatarsDict = Dictionary(uniqueKeysWithValues: zip(users, images))

                    self.tableHeaderView.fillCardsCollection(users: users, images: images)
                    self.updateLoadingAnimation(isLoading: false)
                    self.updateTableViewVisibility(isHidden: false)
            case .loadedNews(let news):
                    self.articles = news
                    self.updateLoadingAnimation(isLoading: false)
                    self.updateTableViewVisibility(isHidden: false)
            case.loadedPosts(let posts):
                    self.runnerPosts = posts
                    self.selectedRunner = posts
                    self.updateLoadingAnimation(isLoading: false)
                    self.updateTableViewVisibility(isHidden: false)
            case .likePost(let likePost):
                for (ind, post) in runnerPosts.enumerated() {
                    if post.postId == likePost.postId {
                        runnerPosts.remove(at: ind)
                        runnerPosts.insert(likePost, at: ind)
                        chooseUser(id: choosenUserId)
                    }
                }
            case .deletePost(let delPostId):
                for (ind, post) in runnerPosts.enumerated() {
                    if post.postId == delPostId {
                        runnerPosts.remove(at: ind)
                        chooseUser(id: choosenUserId)
                    }
                }

            }
        }
    }

    private func updateTableViewVisibility(isHidden: Bool) {
        newsTableView.isHidden = isHidden
        activityIndicator.isHidden = !isHidden
    }

    private func updateLoadingAnimation(isLoading: Bool) {
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }

    //MARK: - Actions

    @objc private func changeSource() {
        switch sourceSegment.selectedSegmentIndex {
        case 0:
            newsTableView.tableHeaderView  = tableHeaderView
            viewModel.updateState(viewInput: .runnersSegment)
            view.backgroundColor = Res.PRColors.prLight
            navigationItem.title = "Участники"
            navigationController?.navigationBar.prefersLargeTitles = true
        case 1:
            newsTableView.reloadData()
            newsTableView.tableHeaderView = nil
            viewModel.updateState(viewInput: .newsSegment)
            view.backgroundColor = Res.MyColors.favoriteBackground
            navigationItem.title = nil
            navigationController?.navigationBar.prefersLargeTitles = false
        default:
            ()
        }
    }

}

// MARK: - Extensions

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sourceSegment.selectedSegmentIndex == 0 ? self.selectedRunner.count : 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        sourceSegment.selectedSegmentIndex == 0 ? 1 : self.articles.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if sourceSegment.selectedSegmentIndex == 1 {
            let sectionHeader = HeaderInSectionView()
            sectionHeader.fillHeader(date: self.articles[section].publishedAt ?? "2001-01-01")
            return sectionHeader
        } else {
            let header = UIView()
            header.heightAnchor.constraint(equalToConstant: 2).isActive = true
            header.backgroundColor = .tintColor
            return header
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sourceSegment.selectedSegmentIndex {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RunnerPostTableViewCell.reuseId, for: indexPath) as? RunnerPostTableViewCell
            else { return RunnerPostTableViewCell() }
            let post = selectedRunner[indexPath.row]
            let avatar = avatarsDict[post.userId] ?? UIImage(named: "dafault-avatar")!
            let iLikeIt = post.likes.contains(AuthManager.shared.currentUser?.uid ?? "")
            let itsme = AuthManager.shared.currentUser?.uid == post.userId
            cell.fillData(with: post, avatar: avatar, iLikeIt: iLikeIt, itsme: itsme)
            cell.cellDelegate = self
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsPostTableViewCell.reuseId, for: indexPath) as? NewsPostTableViewCell
            else { return NewsPostTableViewCell() }
            cell.fillData(with: articles[indexPath.section], indexPath: indexPath)
            cell.cellDelegate = self
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if sourceSegment.selectedSegmentIndex == 0, indexPath != selectedPostRow {
            self.selectedPostRow = indexPath
            tableView.beginUpdates()
            tableView.endUpdates()
        } else if sourceSegment.selectedSegmentIndex == 0 {
            selectedPostRow = nil
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if sourceSegment.selectedSegmentIndex == 0, indexPath == selectedPostRow {
            return 250
        } else if sourceSegment.selectedSegmentIndex == 1 {
            return 480
        } else {
            return 116
        }
    }

}

extension HomeViewController: UsersTableHeaderDelegate {
    func chooseUser(id: String) {
        self.selectedPostRow = nil
        if id != "0" {
            selectedRunner = runnerPosts.filter{ $0.userId == id }
        } else {
            selectedRunner = runnerPosts
        }
        self.choosenUserId = id
    }
}

extension HomeViewController: PostTableCellDelegate {
    func likeDidTap(postId: String) {
        viewModel.updateState(viewInput: .likeDidTap(postId))
    }

    func deleteDidTap(postId: String) {
        viewModel.updateState(viewInput: .delDidTap(postId))
    }
}

extension HomeViewController: NewsCellDelegate {
    func favoriteDidTap(post: Article) {
        viewModel.updateState(viewInput: .addToFavorite(post))
    }

}
