//
//  HomeViewController.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 22.06.2023.
//

import UIKit

final class HomeViewController: UIViewController {

    private let viewModel: HomeViewModel

    private lazy var sourceSegment: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Новости", "Для вас"])
//        segmentedControl.backgroundColor = .secondarySystemBackground
        segmentedControl.selectedSegmentIndex = 0
//        segmentedControl.selectedSegmentTintColor = .systemBackground
        segmentedControl.addTarget(self, action: #selector(changeSource), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()

    private let activityIndicator = UIActivityIndicatorView(style: .large)

    private lazy var newsTableView: UITableView = {
        let tableView = UITableView()
        let header = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 120))
        header.backgroundColor = .lightGray
        tableView.tableHeaderView = header
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "123")
        tableView.rowHeight = 80
        tableView.separatorInset = .zero
        tableView.separatorColor = .tintColor
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.isHidden = true
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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupView()
        bindViewModel()


    }
    deinit {
        print(#function, " HomeViewController 📱")
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

        view.addSubview(newsTableView)

        NSLayoutConstraint.activate([

            newsTableView.topAnchor.constraint(equalTo: view.topAnchor),
            newsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            newsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

        ])

    }
    private func bindViewModel() {

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
        10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "123")
        cell.backgroundColor = .systemYellow
        cell.textLabel?.text = "Hello"
        cell.detailTextLabel?.text = "My friend"

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }


}
