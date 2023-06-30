//
//  ProfileViewController.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 22.06.2023.
//

import UIKit

final class ProfileViewController: UIViewController {

    private let viewModel: ProfileViewModel
    private var isEditable: Bool = false
//    private lazy var profile: Runner? = nil {
//        didSet {
//            self.navigationItem.title = "Привет, \(profile!.nickname)!"
////            self.statusTextField.text = profile?.statusText
//            if profile?.id != AuthManager.shared.currentUser?.uid {
////                statusTextField.isEnabled = false
////                statusTextField.backgroundColor = .systemGray6
//            }
//        }
//    }
//    private lazy var avatar: UIImage? = nil {
//        didSet {
////            self.avatarImageView.image = avatar
//        }
//    }

    private lazy var profileCardView = ProfileCardView(isEditable: self.isEditable)
    
    //MARK: - Init
    
    init(viewModel: ProfileViewModel, isEditable: Bool = false) {
        self.viewModel = viewModel
        self.isEditable = isEditable
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
        view.addSubview(profileCardView)


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
            profileCardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 28),
            profileCardView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
    }


    func bindViewModel() {
        viewModel.onStateDidChange = { [weak self] state in
            guard let self = self else {
                return
            }
            switch state {
            case .initial:
                ()
            case .error(_):
                ()
            case .loadedProfile(let profile):
//                self.profile = profile
                self.profileCardView.fillProfile(profile: profile)
            case .loadedImageData(let imgData):
//                self.avatar = UIImage(data: imgData)
                self.profileCardView.fillAvatar(avatar: UIImage(data: imgData))
            }
        }
    }

    @objc private func logout() {
        viewModel.updateState(viewInput: .logOut)
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
