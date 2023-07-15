//
//  FavoriteViewController.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 22.06.2023.
//

import UIKit

final class FavoriteViewController: UIViewController {

    private let viewModel: FavoriteViewModel

    var savedNews: [Article] = [] {
        didSet {
            runnersImageView.isHidden = !savedNews.isEmpty
            infoLabel.isHidden = !savedNews.isEmpty
        }
    }

    private lazy var newsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NewsPostTableViewCell.self, forCellReuseIdentifier: NewsPostTableViewCell.reuseId)
        tableView.register(HeaderInSectionView.self, forHeaderFooterViewReuseIdentifier: HeaderInSectionView.reuseId)
        tableView.sectionFooterHeight = 0
        tableView.sectionHeaderTopPadding = 0
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    private let infoLabel = UILabel(text: "Здесь будут храниться ваши избранные новости", font: .systemFont(ofSize: 18, weight: .semibold), textColor: .tintColor, lines: 2)

    private let runnersImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "two")
        image.contentMode = .scaleAspectFit
//        image.conte
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private lazy var clearButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(clearButtonTap))
    private lazy var searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTap))

    init(viewModel: FavoriteViewModel) {
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.updateState(viewInput: .fetchFavorites(predicate: nil))
    }

    deinit {
        print(#function, " FavoriteViewController 📱")
    }


    private func setupNavigation() {
        self.navigationItem.title = "Избранное"
        navigationItem.rightBarButtonItems = [searchButton ,clearButton]
        searchButton.isEnabled = true
        clearButton.isEnabled = false
    }

    private func setupView() {
        view.backgroundColor = Res.PRColors.prLight
        view.addSubview(runnersImageView)
        view.addSubview(infoLabel)
        view.addSubview(newsTableView)
        infoLabel.textAlignment = .center

        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),

            runnersImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 16),
            runnersImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            runnersImageView.widthAnchor.constraint(equalToConstant: 250),
            runnersImageView.heightAnchor.constraint(equalToConstant: 250),

            newsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            newsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            newsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }


    // MARK: - ViewModel Binding
    
    func bindViewModel() {
        viewModel.onStateDidChange = { [weak self] state in
            guard let self = self else {
                return
            }
            switch state {

            case .initial:
                ()
            case .favorite(let news):
                self.savedNews = news
                newsTableView.reloadData()
            }
        }

    }





    //MARK: - Actions
    @objc private func searchButtonTap() {
        let alertController = UIAlertController(title: "Поиск статьи", message: "Введите искомое слово из заголовка новости", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.searchButton.isEnabled = false
            self?.clearButton.isEnabled = true
            let filterId = alertController.textFields?.first?.text ?? ""
            self?.viewModel.updateState(viewInput: .fetchFavorites(predicate: NSPredicate(format: "title CONTAINS[cd] %@", filterId)))

        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) {_ in
            self.dismiss(animated: true)
        }
        alertController.addTextField()
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    @objc private func clearButtonTap() {
        self.searchButton.isEnabled = true
        self.clearButton.isEnabled = false
        self.viewModel.updateState(viewInput: .fetchFavorites(predicate: nil))
    }
}


// MARK: - Extensions

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        savedNews.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

            let sectionHeader = HeaderInSectionView()
            sectionHeader.fillHeader(date: self.savedNews[section].publishedAt ?? "2001-01-01")
            return sectionHeader

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsPostTableViewCell.reuseId, for: indexPath) as? NewsPostTableViewCell
        else { return NewsPostTableViewCell() }
        cell.fillData(with: savedNews[indexPath.section], indexPath: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Удалить"
        ) { [weak self] _, _, _ in
            //delete from DB
            let article = self?.savedNews[indexPath.section]
            if let url = article?.url {
                self?.viewModel.updateState(viewInput: .delete(url))
            }
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

}
