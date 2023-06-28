//
//  ProfileViewController.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 22.06.2023.
//

import UIKit

final class ProfileViewController: UIViewController {

    private let viewModel: ProfileViewModel

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        bindViewModel()
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Профиль"
        DatabaseService.shared.getUser(userId: AuthManager.shared.currentUser?.uid ?? "---", completion: { result in
            switch result {
            case .success(let runner):
                DispatchQueue.main.async {
                    self.navigationItem.title = "Привет, \(runner.nickname ?? "")!"
                    print(runner)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
        navigationController?.navigationBar.backgroundColor = .cyan

        let logoutButton = UIBarButtonItem(image: UIImage(systemName: "door.right.hand.open"), style: .done, target: self, action: #selector(logout))
        navigationItem.rightBarButtonItem = logoutButton
    }

    deinit {
        print(#function, " ProfileViewController 📱")
    }


    func bindViewModel() {
        viewModel.onStateDidChange = { [weak self] state in
            //            guard let self = self else {
            //                return
            //            }
            switch state {
            case .initial:
                ()
            case .error(_):
                ()
            }
        }
    }

    @objc private func logout() {
        viewModel.updateState(viewInput: .logOut)
    }

}
