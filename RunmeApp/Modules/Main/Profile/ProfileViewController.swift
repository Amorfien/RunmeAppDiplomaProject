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

    private lazy var profileCardView = ProfileCardView(delegate: self, isEditable: self.isEditable)

    private var statusTemp: String?
    
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

        viewModel.updateState(viewInput: .showUser)

    }

    deinit {
        print(#function, " ProfileViewController 📱")
    }

    private func setupView() {
        view.backgroundColor = Res.PRColors.prRegular
        view.addSubview(profileCardView)

        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 8, height: 0)
        view.layer.shadowOpacity = 0.6
        view.layer.shadowRadius = 10


        NSLayoutConstraint.activate([
            profileCardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            profileCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            profileCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            profileCardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
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
                self.profileCardView.fillProfile(profile: profile)
            case .loadedImageData(let imgData):
                self.profileCardView.fillAvatar(avatar: UIImage(data: imgData))
            }
        }
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
        UIView.animate(withDuration: 0.9) {
            textField.backgroundColor = .white.withAlphaComponent(0.9)
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
            ()
        case .exit:
            viewModel.updateState(viewInput: .logOut)
        }
    }
}
