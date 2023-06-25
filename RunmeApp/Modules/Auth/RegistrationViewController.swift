//
//  RegistrationViewController.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 24.06.2023.
//

import UIKit

final class RegistrationViewController: UIViewController {

    // MARK: - Properties
    let viewModel: LoginViewModel

    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mosaic")
        imageView.layer.cornerRadius = 75
        imageView.layer.borderWidth = 1
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let button = UIButton(frame: CGRect(x: 0, y: 120, width: 150, height: 30))
        button.backgroundColor = .white.withAlphaComponent(0.8)
        button.setTitle("➕", for: .normal)
        button.addTarget(self, action: #selector(addButtonDidTap), for: .touchUpInside)
        imageView.addSubview(button)
        return imageView
    }()

    private let vStack: UIStackView = {
        let stack = UIStackView()
//        stack.backgroundColor = .systemGray3
        stack.axis = .vertical
        stack.spacing = 28
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let nameTextField = CustomTextField(placeholder: .name)
    private let surnameTextField = CustomTextField(placeholder: .surname)
    private let nicknameTextField = CustomTextField(placeholder: .nickname)
    private let birthdayTextField = CustomTextField(placeholder: .birthday)

    private lazy var nextButton: LoginButton = {
        let button = LoginButton()
        button.setTitle("Next", for: .normal)
//        button.isEnabled = false
        button.addTarget(self, action: #selector(nextDidTap), for: .touchUpInside)
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
        setupGestures()
    }

    private func setupView() {
        self.title = "Registration"
        view.backgroundColor = .systemGray5
        view.addSubview(avatarImageView)
        view.addSubview(vStack)
        let textFields = [nameTextField, surnameTextField, nicknameTextField, birthdayTextField]

        for (tag, textField) in textFields.enumerated() {
            vStack.addArrangedSubview(textField)
            textField.delegate = self
            textField.tag = tag
        }

        birthdayTextField.keyboardType = .decimalPad

        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([

            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.heightAnchor.constraint(equalToConstant: 150),
            avatarImageView.widthAnchor.constraint(equalToConstant: 150),

            vStack.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 40),
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),

            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.topAnchor.constraint(equalTo: vStack.bottomAnchor, constant: 40),
            nextButton.widthAnchor.constraint(equalToConstant: 200),
            nextButton.heightAnchor.constraint(equalToConstant: 40),
            nextButton.bottomAnchor.constraint(greaterThanOrEqualTo: view.keyboardLayoutGuide.topAnchor, constant: -20),
        ])
    }


    // MARK: - Actions

    @objc private func addButtonDidTap() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }

    @objc private func nextDidTap() {

        let runner = Runner(
            id: AuthManager.shared.currentUser?.uid ?? "---",
            phoneNumber: AuthManager.shared.currentUser?.phoneNumber ?? "---",
            name: nameTextField.text,
            surname: surnameTextField.text,
            nickname: nicknameTextField.text,
            avatar: avatarImageView.image,
            birthday: birthdayTextField.text)

        viewModel.updateState(viewInput: .registerButtonDidTap(runner))

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

extension RegistrationViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        switch textField.tag {
        case 0: surnameTextField.becomeFirstResponder()
        case 1: nicknameTextField.becomeFirstResponder()
        case 2: birthdayTextField.becomeFirstResponder()
        default: hideKeyboard()
        }
        return true

    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard textField.tag == 3 else { return }
        guard let text = textField.text else { return }
        if text.count > 8 {
            textField.deleteBackward()
        } else if text.count == 2 || text.count == 5 {
            textField.text! += "." //проблема со стиранием (нельзя ошибаться)
        }
    }

}

extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            avatarImageView.image = pickedImage
        }
        picker.dismiss(animated: true)
    }

}
