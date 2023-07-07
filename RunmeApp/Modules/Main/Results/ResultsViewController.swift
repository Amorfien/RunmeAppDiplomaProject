//
//  ResultsViewController.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 02.07.2023.
//

import UIKit

final class ResultsViewController: UIViewController {

    private let viewModel: ResultsViewModel

    private lazy var itsMe = AuthManager.shared.currentUser?.uid

    private var rrunners: [RunnersBests] = []
    private var tableRunners: [RunnersBests] = [] {
        didSet {
            resultsTableView.reloadData()
        }
    }

    private lazy var distanceSegment: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["5 км", "10 км", "21.1 км", "42.2 км"])
        segmentedControl.selectedSegmentTintColor = .tintColor
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(changeDistance), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()

    private lazy var sexSegment: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["🚹", "🚺"])
        segmentedControl.frame.size.height = 20
        segmentedControl.frame.size.width = 150
        segmentedControl.addTarget(self, action: #selector(changeSex), for: .valueChanged)
        return segmentedControl
    }()

    private lazy var resultsTableView: UITableView = {
        let tableView = UITableView()
        tableView.tableHeaderView = sexSegment
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "standartCell")
        tableView.separatorInset = .zero
        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    private let activityIndicator = UIActivityIndicatorView(style: .large)

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
//        viewModel.updateState(viewInput: .needUpdate)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            resultsTableView.topAnchor.constraint(equalTo: view.topAnchor),
            resultsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            resultsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            resultsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

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
                ()
            case .loading:
                updateResultsVisibility(isHidden: true)
                updateLoadingAnimation(isLoading: true)
                sexSegment.selectedSegmentIndex = UISegmentedControl.noSegment
            case .loadedResults(let bests):
                updateResultsVisibility(isHidden: false)
                updateLoadingAnimation(isLoading: false)
                self.rrunners = bests
                self.tableRunners = bests
                distanceSegment.selectedSegmentIndex = 0 
            }
        }
    }

    private func updateResultsVisibility(isHidden: Bool) {
        resultsTableView.isHidden = isHidden
        activityIndicator.isHidden = !isHidden
    }
    private func updateLoadingAnimation(isLoading: Bool) {
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }



    @objc private func changeDistance(_ sender: UISegmentedControl) {
        rrunners.sort { lhs, rhs in
            lhs.personalBests[sender.selectedSegmentIndex] < rhs.personalBests[sender.selectedSegmentIndex]
        }
        tableRunners = rrunners
        sexSegment.selectedSegmentIndex = UISegmentedControl.noSegment
    }

    @objc private func changeSex(_ sender: UISegmentedControl) {
        sender.selectedSegmentTintColor = sender.selectedSegmentIndex == 0 ? .blue : .systemPink
        tableRunners = rrunners.filter{ sender.selectedSegmentIndex == 0 ? $0.isMale : !$0.isMale }
    }



}

// MARK: - Extensions

extension ResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableRunners.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .value1, reuseIdentifier: "standartCell")
        let runner = tableRunners[indexPath.row]
        let time = runner.personalBests[distanceSegment.selectedSegmentIndex]
        let nickname = runner.nickname

        cell.textLabel?.font = .monospacedSystemFont(ofSize: 14, weight: .regular)
        cell.textLabel?.text = timeFormat(sec: time, isMale: runner.isMale)
        cell.detailTextLabel?.lineBreakMode = .byTruncatingMiddle
        cell.detailTextLabel?.text = "\(nickname)  - \(indexPath.row + 1)"
        cell.backgroundColor = runner.isMale ? .systemBlue.withAlphaComponent(0.07) : .systemPink.withAlphaComponent(0.07)

        if time > 0, time < 100000, itsMe == runner.id {
            cell.backgroundColor = .systemYellow.withAlphaComponent(0.4)
        }
        if runner.id == "_adminadmin" {
            cell.backgroundColor = .clear
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let runner = tableRunners[indexPath.row]
        print(runner.personalBests)
        viewModel.updateState(viewInput: .chooseUser(runner.id))
    }


}
