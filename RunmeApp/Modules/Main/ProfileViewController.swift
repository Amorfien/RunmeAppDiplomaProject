//
//  ProfileViewController.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 22.06.2023.
//

import UIKit

final class ProfileViewController: UIViewController {

    private let viewModel: ProfileViewModel?

    private let profile: Runner?

    private let avatarImageView = AvatarCircleView(image: nil, size: .large)

    init(viewModel: ProfileViewModel?, profile: Runner?) {
        self.viewModel = viewModel
        self.profile = profile
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

        DatabaseService.shared.getUser(userId: AuthManager.shared.currentUser?.uid ?? "---", completion: { result in
            switch result {
            case .success(let runner):
                DispatchQueue.main.async {
                    self.navigationItem.title = "Привет, \(runner.nickname)!"
//                    print(runner)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })

    }

    deinit {
        print(#function, " ProfileViewController 📱")
    }

    private func setupNavigation() {
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Профиль"
//        navigationController?.navigationBar.backgroundColor = .cyan
        let logoutButton = UIBarButtonItem(image: UIImage(systemName: "door.right.hand.open"), style: .done, target: self, action: #selector(logout))
        navigationItem.rightBarButtonItem = logoutButton
    }

    private func setupView() {
        view.backgroundColor = Res.MyColors.profileBackground
        view.addSubview(avatarImageView)

        if viewModel == nil {
            FirebaseStorageService.shared.downloadById(id: profile!.id, completion: { result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        self.avatarImageView.image = image
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        self.avatarImageView.image = UIImage(named: "dafault-avatar")!
                    }
                }
            })

        }

        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
            ])
    }


    func bindViewModel() {
        guard let viewModel else { return }
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
        guard let viewModel else { return }
        viewModel.updateState(viewInput: .logOut)
    }

}
