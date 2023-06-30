//
//  ProfileViewController.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 22.06.2023.
//

import UIKit

final class ProfileViewController: UIViewController {

    private let viewModel: ProfileViewModel
    private lazy var profile: Runner? = nil {
        didSet {
            self.navigationItem.title = "Привет, \(profile!.nickname)!"
            self.statusLabel.text = profile?.statusText
        }
    }
    private lazy var avatar: UIImage? = nil {
        didSet {
            self.avatarImageView.image = avatar
        }
    }
    private var isEditable = false
    private lazy var avatarImageView = AvatarCircleImageView(image: nil, size: .xLarge, isEditable: self.isEditable, completion: changeAvatar)

    private let statusLabel = UILabel(text: "", font: .systemFont(ofSize: 14), textColor: .secondaryLabel)
    private let statusTextField = CustomTextField(type: .status)

    
    //MARK: - Init
    
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
        setupNavigation()
        setupView()
        setupGestures()

        bindViewModel()

        viewModel.updateState(viewInput: .showUser)

//        DatabaseService.shared.getUser(userId: AuthManager.shared.currentUser?.uid ?? "---", completion: { result in
//            switch result {
//            case .success(let runner):
//                DispatchQueue.main.async {
//                    self.profile = runner
//
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        })

    }

    deinit {
        print(#function, " ProfileViewController 📱")
    }

    private func setupNavigation() {
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Профиль"
        let logoutButton = UIBarButtonItem(image: UIImage(systemName: "door.right.hand.open"), style: .done, target: self, action: #selector(logout))
        navigationItem.rightBarButtonItem = logoutButton
    }

    private func setupView() {
        view.backgroundColor = Res.MyColors.profileBackground
        view.addSubview(avatarImageView)
        view.addSubview(statusLabel)
        view.addSubview(statusTextField)


//            FirebaseStorageService.shared.downloadById(id: profile!.id, completion: { result in
//                switch result {
//                case .success(let image):
//                    DispatchQueue.main.async {
//                        self.avatarImageView.image = image
//                    }
//                case .failure(let error):
//                    print(error.localizedDescription)
//                    DispatchQueue.main.async {
//                        self.avatarImageView.image = UIImage(named: "dafault-avatar")!
//                    }
//                }
//            })



        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            statusLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            statusLabel.heightAnchor.constraint(equalToConstant: 22),

            statusTextField.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 12),
            statusTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            statusTextField.heightAnchor.constraint(equalToConstant: 22),
            ])
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
            case .loadedProfile(let profile):
                self?.profile = profile
            case .loadedImageData(let imgData):
                self?.avatar = UIImage(data: imgData)
            }
        }
    }

    @objc private func logout() {
        viewModel.updateState(viewInput: .logOut)
    }

    @objc private func changeAvatar() {
        print("ImagePicker")
    }

    //  жест чтобы скрывать клавиатуру по тапу
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }

}
