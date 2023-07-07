//
//  HomeViewController.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 22.06.2023.
//

import UIKit

final class HomeViewController: UIViewController {

    private let viewModel: HomeViewModel

    //    var avatars: [UIImage] = [] {
    //        didSet {
    //                self.newsTableView.reloadData()
    //        }
    //    }
    var articles: [Article] = [] {
        didSet {
                self.newsTableView.reloadData()
        }
    }
    var runnerPosts: [RunnerPost] = [] {
        didSet {
                self.newsTableView.reloadData()
        }
    }

    private lazy var sourceSegment: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Для вас", "Новости"])
//        segmentedControl.backgroundColor = .secondarySystemBackground
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
//        tableView.estimatedSectionHeaderHeight = 20
        tableView.sectionFooterHeight = 0
        tableView.sectionHeaderTopPadding = 0
        tableView.backgroundColor = sourceSegment.selectedSegmentIndex == 0 ? Res.PRColors.prLight : Res.MyColors.myBackground//Res.MyColors.homeBackground
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .zero
        tableView.separatorColor = .tintColor
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
//        tableView.sectionHeaderHeight = 50
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
//        viewModel.updateState(viewInput: .runnersSegment)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.updateState(viewInput: .runnersSegment)
    }

    private func setupNavigation() {
        navigationItem.title = "Главная"
        navigationController?.navigationBar.prefersLargeTitles = true
//        lazy var notifyButton = UIBarButtonItem(image: UIImage(systemName: "bell"), style: .plain, target: self, action: #selector(notifyButtonTap))
        lazy var searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTap))
//        navigationItem.rightBarButtonItems = [notifyButton, searchButton]
        navigationItem.rightBarButtonItem = searchButton

//        navigationController?.navigationBar.addSubview(sourceSegment)
        navigationItem.titleView = sourceSegment
        sourceSegment.widthAnchor.constraint(equalToConstant: 240).isActive = true
    }
    private func setupView() {
        tableHeaderView.headerDelegate = self
//        view.backgroundColor = .secondarySystemBackground
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
            activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),


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

                DispatchQueue.main.async {
//                    let header = self.newsTableView.tableHeaderView as! FriendCardsCollectionView
//                    header.fillCardsCollection(users: users, images: images)
                    self.tableHeaderView.fillCardsCollection(users: users, images: images)
                    self.updateLoadingAnimation(isLoading: false)
                    self.updateTableViewVisibility(isHidden: false)
                }
            case .loadedNews(let news):
                DispatchQueue.main.async {
                    self.articles = news
                    self.updateLoadingAnimation(isLoading: false)
                    self.updateTableViewVisibility(isHidden: false)
                }
            case.loadedPosts(let posts):
                DispatchQueue.main.async {
                    self.runnerPosts = posts
                    self.updateLoadingAnimation(isLoading: false)
                    self.updateTableViewVisibility(isHidden: false)
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
    @objc private func searchButtonTap() {

    }
    @objc private func notifyButtonTap() {

    }
    @objc private func changeSource() {
//        cell.backgroundColor = sourceSegment.selectedSegmentIndex == 0 ? Res.MyColors.homeBackground : Res.MyColors.myBackground
        switch sourceSegment.selectedSegmentIndex {
        case 0:
            newsTableView.tableHeaderView  = tableHeaderView
            viewModel.updateState(viewInput: .runnersSegment)
            view.backgroundColor = Res.PRColors.prLight
            newsTableView.backgroundColor = Res.PRColors.prLight
        case 1:
            newsTableView.tableHeaderView = nil
            viewModel.updateState(viewInput: .newsSegment)
            view.backgroundColor = Res.MyColors.myBackground
            newsTableView.backgroundColor = Res.MyColors.myBackground
        default:
            ()
        }
    }


}

// MARK: - Extensions

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sourceSegment.selectedSegmentIndex == 0 ? self.runnerPosts.count : 1
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
            return nil
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sourceSegment.selectedSegmentIndex {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RunnerPostTableViewCell.reuseId, for: indexPath) as? RunnerPostTableViewCell
            else { return RunnerPostTableViewCell() }

            cell.fillData(with: runnerPosts[indexPath.row], indexPath: indexPath)
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsPostTableViewCell.reuseId, for: indexPath) as? NewsPostTableViewCell
            else { return NewsPostTableViewCell() }

            cell.fillData(with: articles[indexPath.section], indexPath: indexPath)
            return cell
        }


    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }


}



extension HomeViewController: UsersTableHeaderDelegate {
    func chooseUser(id: String) {
//        showAlert(title: "User", message: id) {
//            self.dismiss(animated: true)
//        }
        viewModel.updateState(viewInput: .chooseUser(id))
    }
}
