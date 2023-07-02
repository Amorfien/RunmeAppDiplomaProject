//
//  ResultsViewController.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 02.07.2023.
//

import UIKit

final class ResultsViewController: UIViewController {

    private let viewModel: ResultsViewModel

    private lazy var distanceSegment: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["5 км", "10 км", "21.0975", "МАРАФОН"])
//        segmentedControl.backgroundColor = .secondarySystemBackground
        segmentedControl.selectedSegmentTintColor = .tintColor
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(changeDistance), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()

    private lazy var resultsTableView: UITableView = {
        let tableView = UITableView()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "standartCell")
        tableView.separatorInset = .zero
        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    //MARK: - Init

    init(viewModel: ResultsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print(#function, " ResultsViewController 📱")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupView()
        bindViewModel()
        viewModel.updateState(viewInput: .changeDist(0))
    }

    
    private func setupNavigation() {
        navigationItem.title = "Результаты"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.titleView = distanceSegment
        distanceSegment.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 32).isActive = true
    }

    private func setupView() {
        view.backgroundColor = Res.MyColors.homeBackground
        view.addSubview(resultsTableView)

        NSLayoutConstraint.activate([

            resultsTableView.topAnchor.constraint(equalTo: view.topAnchor),
            resultsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            resultsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            resultsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

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
                ()
            case .loading:
                ()
            case .loadedResults(_):
                ()
            }
        }
    }



    @objc private func changeDistance() {
        viewModel.updateState(viewInput: .changeDist(distanceSegment.selectedSegmentIndex))
    }




}

// MARK: - Extensions

extension ResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "standartCell", for: indexPath) as? UITableViewCell
//        else { return UITableViewCell() }

        let cell = tableView.dequeueReusableCell(withIdentifier: "standartCell", for: indexPath)
        cell.textLabel?.text = String(indexPath.row + 1)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }


}
