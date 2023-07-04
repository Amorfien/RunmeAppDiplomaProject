//
//  ResultsViewController.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 02.07.2023.
//

import UIKit

final class ResultsViewController: UIViewController {

    private let viewModel: ResultsViewModel

//    private let fiveKmArray: [String: Int] = [:]
//    private let tenKmArray: [Int] = []
//    private let twentyKmArray: [Int] = []
//    private let fortyKmArray: [Int] = []

    private var runners: [RunnersBests] = [] {
        didSet {
            resultsTableView.reloadData()
        }
    }

    private lazy var distanceSegment: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["5 км", "10 км", "21.1 км", "МАРАФОН"])
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
        viewModel.updateState(viewInput: .needUpdate)


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
            case .loadedResults(let bests):
                self.runners = bests
            }
        }
    }



    @objc private func changeDistance(_ sender: UISegmentedControl) {
        runners.sort { lhs, rhs in
            lhs.personalBests[sender.selectedSegmentIndex] < rhs.personalBests[sender.selectedSegmentIndex]
        }
    }




}

// MARK: - Extensions

extension ResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        runners.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .value1, reuseIdentifier: "standartCell")
        let runner = runners[indexPath.row]
        let time = runner.personalBests[distanceSegment.selectedSegmentIndex]
        let nickname = runner.nickname

        cell.textLabel?.font = .monospacedSystemFont(ofSize: 14, weight: .regular)
        cell.textLabel?.text = timeFormat(sec: time, isMale: runner.isMale)
        cell.detailTextLabel?.lineBreakMode = .byTruncatingMiddle
        cell.detailTextLabel?.text = "\(nickname)  - \(indexPath.row + 1)"

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let runner = runners[indexPath.row]
        print(runner.personalBests)
        viewModel.updateState(viewInput: .chooseUser(runner.id))
    }


}
