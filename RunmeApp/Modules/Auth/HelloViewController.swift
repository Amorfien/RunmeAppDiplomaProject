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

    private lazy var bioLoginButton: UIButton = {
        let button = UIButton()

        button.tintColor = .systemGray
        button.setTitleColor(.label, for: .normal)

        button.titleLabel?.font = .monospacedDigitSystemFont(ofSize: 22, weight: .medium)
        button.addTarget(self, action: #selector(bioLoginDidTap), for: .touchUpInside)
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
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

        setupView()
        bindViewModel()

        viewModel.initialState { sensorType, userPhone in
            bioLoginButton.setImage(UIImage(systemName: sensorType), for: .normal)
            bioLoginButton.setTitle("    " + userPhone, for: .normal)
        }
        
    }

    deinit {
        print(#function, " LoginViewController 📱")
    }

    // MARK: - ViewModel Binding

    func bindViewModel() {
        viewModel.onStateDidChange = { [weak self] state in
            guard let self = self else {
                return
            }
            switch state {
            case .identifiedUser:
                self.loginButton.setTitle("Другой пользователь  📲", for: .normal)
                self.bioLoginButton.isHidden = false
            case .noUser:
                self.loginButton.setTitle("Войти по номеру телефона  📲", for: .normal)
                self.bioLoginButton.isHidden = true
            case .okay:
                  DispatchQueue.main.async {
                      self.bioLoginButton.tintColor = .systemBlue
                  }
            case .error(_):
                ()
            }
        }
    }

    // MARK: - Private methods

    private func setupView() {
        view.backgroundColor = .systemGray4
        view.addSubview(helloImageView)
        view.addSubview(loginButton)
        view.addSubview(bioLoginButton)

        NSLayoutConstraint.activate([
            helloImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            helloImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            helloImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            helloImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),

            bioLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bioLoginButton.topAnchor.constraint(equalTo: helloImageView.bottomAnchor, constant: 32),
            bioLoginButton.widthAnchor.constraint(equalToConstant: 288),
            bioLoginButton.heightAnchor.constraint(equalToConstant: 48),

            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: helloImageView.bottomAnchor, constant: 120),
            loginButton.widthAnchor.constraint(equalToConstant: 288),
            loginButton.heightAnchor.constraint(equalToConstant: 48),


        ])
    }

    // MARK: - Actions

    @objc private func loginDidTap() {
        viewModel.updateState(viewInput: .helloButtonDidTap)
    }

    @objc private func bioLoginDidTap() {
        viewModel.updateState(viewInput: .loginWithBio)
    }

}

