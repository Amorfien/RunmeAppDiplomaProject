//
//  LoginViewController.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 22.06.2023.
//

import UIKit

final class LoginViewController: UIViewController {

    private let viewModel: LoginViewModel

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

        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 200, height: 50))
        button.backgroundColor = .tintColor
        button.setTitle("Login", for: .normal)
        view.addSubview(button)
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        bindViewModel()
        
    }

    deinit {
        print(#function, " LoginViewController 📱")
    }

    func bindViewModel() {
        viewModel.onStateDidChange = { [weak self] state in
//            guard let self = self else {
//                return
//            }
            switch state {
            case .initial:
                ()
            case .loading:
                ()
            case .success:
                ()
            case .error:
                // Here we can show alert with error text
                ()
            }
        }
    }

    @objc private func login() {
        viewModel.updateState(viewInput: .loadButtonDidTap)
    }

}

