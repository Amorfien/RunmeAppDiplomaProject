//
//  SettingsViewController.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 05.07.2023.
//

import UIKit

final class SettingsViewController: UIViewController {

    let viewModel: ProfileViewModel

    private lazy var settingsView = RegistrationView(delegate: self)

    //MARK: - Init

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        print(#function, " RegistrationViewController 📱")
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        settingsView.settingsScreen(profile: viewModel.fetchedUser)
        setupView()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        settingsView.updateUser()
    }

    deinit {
        print(#function, " SettingsViewController 📱")
    }


    private func setupView() {
        view.backgroundColor = Res.PRColors.prRegular
        view.addSubview(settingsView)
        settingsView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            settingsView.topAnchor.constraint(equalTo: view.topAnchor),
            settingsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            settingsView.heightAnchor.constraint(equalToConstant: 500)
            ])
    }
    
}


extension SettingsViewController: UIScrollViewDelegate {}
