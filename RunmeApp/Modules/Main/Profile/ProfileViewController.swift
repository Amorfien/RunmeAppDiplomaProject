//
//  ProfileViewController.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 22.06.2023.
//

import UIKit

final class ProfileViewController: UIViewController {

    let viewModel: ProfileViewModel
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private var isEditable: Bool = false
    private var achievements: [String] = []

    private lazy var profileCardView = ProfileCardView(delegate: self, isEditable: self.isEditable)

    private var statusTemp: String?

//    private lazy var settingsView = RegistrationView(delegate: self)
    
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
        setupView()
        setupGestures()

        bindViewModel()



    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        viewModel.updateState(viewInput: .showUser)//_________________________________________
    }

    deinit {
        print(#function, " ProfileViewController 📱")
    }

    private func setupView() {
        view.backgroundColor = Res.PRColors.prMedium
        view.addSubview(profileCardView)
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            profileCardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            profileCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            profileCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            profileCardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
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
            case .loading:
                updateProfileVisibility(isHidden: true)
                updateLoadingAnimation(isLoading: true)
            case .loadedProfile(let profile):
                updateProfileVisibility(isHidden: false)
                updateLoadingAnimation(isLoading: false)
                self.profileCardView.fillProfile(profile: profile)
                self.achievements = profile.achievements ?? []
            case .loadedImageData(let imgData):
                self.profileCardView.fillAvatar(avatar: UIImage(data: imgData))
            case .settings(let user):
                 let settingsView = RegistrationView(delegate: self)
                settingsView.settingsScreen(profile: user)
                self.view = settingsView
            case .error(_):
                ()
            }
        }
    }

    private func updateProfileVisibility(isHidden: Bool) {
        profileCardView.isHidden = isHidden
        activityIndicator.isHidden = !isHidden
    }
    private func updateLoadingAnimation(isLoading: Bool) {
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
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


//MARK: - Extensions
extension ProfileViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        statusTemp = textField.text
        UIView.animate(withDuration: 0.8) {
            textField.backgroundColor = .white.withAlphaComponent(0.95)
        }
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.4) {
            textField.backgroundColor = .white.withAlphaComponent(0.1)
        }
        if statusTemp != textField.text {
            viewModel.updateState(viewInput: .saveStatus(textField.text ?? ""))
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
    
}

/// делегат пикера картинок
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileCardView.avatar = pickedImage
            viewModel.updateState(viewInput: .savePhoto(pickedImage))
        }
        picker.dismiss(animated: true)
    }

}

/// делегат бокового меню
extension ProfileViewController: SlideMenuDelegate {
    func menuItemTap(_ item: SlideMenu) {
//        print(item.rawValue, " 🗓️")
        switch item {
        case .files:
            ()
        case .bookmarks:
            ()
        case .favorite:
            ()
        case .settings:
            viewModel.updateState(viewInput: .menuSettings)
        case .exit:
            viewModel.updateState(viewInput: .logOut)
        }
    }
}

/// делегат коллекции ачивок
extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.achievements.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AchievementCell", for: indexPath)
        cell.backgroundColor = Res.PRColors.prLight
        cell.layer.cornerRadius = 10
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 1
        let achImgView = UIImageView(image: UIImage(named: achievements[indexPath.item]))
        achImgView.contentMode = .scaleAspectFit
        cell.backgroundView = achImgView
        return cell
    }

}
extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.frame.width - 48) / 3
        return CGSize(width: itemWidth, height: itemWidth)
    }
}

/// делегат скролла ачивок
extension ProfileViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x > 0 {
                self.profileCardView.achButton.alpha = 0
                self.profileCardView.achButton.isHidden = true
        } else {
            profileCardView.achButton.isHidden = false
            UIView.animate(withDuration: 0.4) {
                self.profileCardView.achButton.alpha = 1
            }
        }
    }

}

extension ProfileViewController: SettingsDelegate {
    func userUpdate() {
        viewModel.updateState(viewInput: .showUser)
    }


}
