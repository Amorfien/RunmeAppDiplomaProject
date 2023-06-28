//
//  HomeViewController.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 22.06.2023.
//

import UIKit

final class HomeViewController: UIViewController {

    private let viewModel: HomeViewModel

    var articles: [Article] = [] {
        didSet {
                self.newsTableView.reloadData()
        }
    }

    private lazy var sourceSegment: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Новости", "Для вас"])
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
        tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 90)
        tableView.register(NewsPostTableViewCell.self, forCellReuseIdentifier: NewsPostTableViewCell.reuseId)
        tableView.register(HeaderInSectionView.self, forHeaderFooterViewReuseIdentifier: HeaderInSectionView.reuseId)
        tableView.backgroundColor = Res.MyColors.homeBackground
//        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.isHidden = true
        tableView.sectionHeaderHeight = 50
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
        viewModel.updateState(viewInput: .reload)
    }

    private func setupNavigation() {
        navigationItem.title = "Главная"
        navigationController?.navigationBar.prefersLargeTitles = true
        lazy var notifyButton = UIBarButtonItem(image: UIImage(systemName: "bell"), style: .plain, target: self, action: #selector(notifyButtonTap))
        lazy var searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTap))
        navigationItem.rightBarButtonItems = [notifyButton, searchButton]

//        navigationController?.navigationBar.addSubview(sourceSegment)
        navigationItem.titleView = sourceSegment
        sourceSegment.widthAnchor.constraint(equalToConstant: 270).isActive = true
    }
    private func setupView() {
//        view.backgroundColor = .secondarySystemBackground
        view.backgroundColor = Res.MyColors.homeBackground

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
    private func bindViewModel() {
        viewModel.onStateDidChange = { [weak self] state in
            guard let self = self else {
                return
            }
            switch state {
            case .initial:
                ()
            case .loading:
                updateTableViewVisibility(isHidden: true)
                updateLoadingAnimation(isLoading: true)
            case .loaded(let news):
                DispatchQueue.main.async {
                    self.articles = news
                    self.updateLoadingAnimation(isLoading: false)
                    self.updateTableViewVisibility(isHidden: false)
                }
            case .error(_):
                ()
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

    }


}

// MARK: - Extensions

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        self.articles.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = HeaderInSectionView()
        sectionHeader.fillHeader(date: self.articles[section].publishedAt ?? Date().description)
        return sectionHeader
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsPostTableViewCell.reuseId, for: indexPath) as? NewsPostTableViewCell
        else { return NewsPostTableViewCell() }

        cell.fillData(with: articles[indexPath.section], indexPath: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }


}
