//
//  LoginViewController.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 22.06.2023.
//

import UIKit

final class HelloViewController: UIViewController {

    // MARK: - Properties
    private let viewModel: LoginViewModel

    private let helloImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "figure.run.circle")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private lazy var loginButton: LoginButton = {
        let button = LoginButton()
        button.setTitle("Enter by Phone", for: .normal)
//        button.isEnabled = false
        button.addTarget(self, action: #selector(loginDidTap), for: .touchUpInside)
        return button
    }()

    //MARK: - Init

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow

        setupView()
        bindViewModel()
        
    }

    deinit {
        print(#function, " LoginViewController 📱")
    }

    // MARK: - ViewModel Binding

    func bindViewModel() {
        viewModel.onStateDidChange = { [weak self] state in
//            guard let self = self else {
//                return
//            }
            switch state {
            case .initial:
                ()

            case .error:
                // Here we can show alert with error text
                ()
            }
        }
    }

    // MARK: - Private methods

    private func setupView() {
        view.backgroundColor = .systemGray4
        view.addSubview(helloImageView)
        view.addSubview(loginButton)

        NSLayoutConstraint.activate([
            helloImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            helloImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80),
            helloImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            helloImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),

            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: helloImageView.bottomAnchor, constant: 48),
//            loginButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -50),
            loginButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }

    // MARK: - Actions

    @objc private func loginDidTap() {
//        viewModel.updateState(viewInput: .loadButtonDidTap)
        viewModel.coordinator?.pushPhoneViewController()
    }

}

