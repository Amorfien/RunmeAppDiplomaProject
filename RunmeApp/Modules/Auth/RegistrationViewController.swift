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

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "dafault-avatar")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 80
        imageView.layer.borderWidth = 1
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let button = UIButton(frame: CGRect(x: 0, y: 120, width: 160, height: 40))
        button.backgroundColor = .white.withAlphaComponent(0.8)
        button.setTitle("➕", for: .normal)
        button.addTarget(self, action: #selector(addButtonDidTap), for: .touchUpInside)
        imageView.addSubview(button)
        return imageView
    }()

    private let vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 40
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let nicknameTextField = CustomTextField(type: .nickname)
    private let nameTextField = CustomTextField(type: .name)
    private let surnameTextField = CustomTextField(type: .surname)
    private let emailTextField = CustomTextField(type: .email)
    private let telegramTextField = CustomTextField(type: .telegram)
    private let hStack = UIStackView()
    private let birthdayTextField = CustomTextField(type: .birthday)
//    private let sexSegment = UISegmentedControl(items: ["Муж", "Жен"])

    private lazy var sexSegment: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Муж", "Жен"])
//        segmentedControl.backgroundColor = .secondarySystemBackground
        segmentedControl.selectedSegmentTintColor = .tintColor
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(changeSource), for: .valueChanged)
        return segmentedControl
    }()

    private let doneImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "done")
        image.contentMode = .scaleAspectFit
        image.alpha = 0
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private lazy var nextButton: LoginButton = {
        let button = LoginButton()
        button.setTitle("Готово", for: .normal)
        button.isEnabled = false
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
        self.title = "Регистрация"
        view.backgroundColor = .systemGray5
        view.addSubview(scrollView)
        scrollView.addSubview(avatarImageView)
        scrollView.addSubview(vStack)
        scrollView.addSubview(doneImageView)
        let textFields = [nicknameTextField, nameTextField, surnameTextField, emailTextField, telegramTextField, birthdayTextField]

        for (tag, textField) in textFields.enumerated() {
            if textField != birthdayTextField {
                vStack.addArrangedSubview(textField)
            }
            textField.delegate = self
            textField.tag = tag
        }
        hStack.addArrangedSubview(birthdayTextField)
        hStack.addArrangedSubview(sexSegment)
        hStack.spacing = 16
        hStack.distribution = .fillProportionally
        vStack.addArrangedSubview(hStack)

        birthdayTextField.keyboardType = .decimalPad
        emailTextField.keyboardType = .emailAddress
        telegramTextField.keyboardType = .emailAddress

        view.addSubview(nextButton)

        NSLayoutConstraint.activate([

            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            avatarImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24),
            avatarImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            avatarImageView.heightAnchor.constraint(equalToConstant: 160),
            avatarImageView.widthAnchor.constraint(equalToConstant: 160),

            vStack.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 48),
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
//            vStack.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -220),

            doneImageView.topAnchor.constraint(equalTo: vStack.bottomAnchor, constant: 32),
            doneImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: -32),
            doneImageView.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.contentLayoutGuide.bottomAnchor, constant: 0),
            doneImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.65),
            doneImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.65),

            nextButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -12),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.widthAnchor.constraint(equalToConstant: 150),

        ])
    }


    // MARK: - Actions

    @objc private func addButtonDidTap() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }

    @objc private func changeSource() {

    }

    @objc private func nextDidTap() {

        let runner = Runner(
            id: AuthManager.shared.currentUser?.uid ?? "---",
            phoneNumber: AuthManager.shared.currentUser?.phoneNumber ?? "---",
            nickname: nicknameTextField.text,
            name: nameTextField.text,
            surname: surnameTextField.text,
            isMale: sexSegment.selectedSegmentIndex == 0 ? true : false,
            email: emailTextField.text,
            telegram: telegramTextField.text,
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
        case 0: nameTextField.becomeFirstResponder()
        case 1: surnameTextField.becomeFirstResponder()
        case 2: emailTextField.becomeFirstResponder()
        case 3: telegramTextField.becomeFirstResponder()
        case 4: birthdayTextField.becomeFirstResponder()
        default: hideKeyboard()
        }
        return true

    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.tag == 0 {
            guard let text = textField.text else { return }
            if text.count > 2 {
                nextButton.isEnabled = true
                nextButton.isSelected = false
            } else {
                nextButton.isEnabled = false
            }
        }
        guard textField.tag == 5 else { return }
        guard let text = textField.text else { return }
        if text.count > 8 {
            textField.deleteBackward()
        } else if text.count == 2 || text.count == 5 {
            textField.text! += "." //проблема со стиранием (нельзя ошибаться)
        }
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.frame.midY + 330 > view.frame.midY {
            scrollView.contentOffset.y = textField.frame.minY - 100
        }
        return true
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

extension RegistrationViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            let alpha = (100 + scrollView.contentOffset.y - 20) / 100
            doneImageView.alpha = alpha
        } else {
            doneImageView.alpha = 1
        }
    }
}
