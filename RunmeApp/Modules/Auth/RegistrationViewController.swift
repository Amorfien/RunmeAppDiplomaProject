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

    private lazy var avatarImageView = AvatarCircleImageView(
        image: UIImage(named: "dafault-avatar"),
        size: .large, isEditable: true,
        completion: addButtonDidTap
    )

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

    private lazy var sexSegment: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Муж", "Жен"])
        segmentedControl.selectedSegmentTintColor = .tintColor
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(changeSex), for: .valueChanged)
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

    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChange), for: UIControl.Event.valueChanged)
        datePicker.frame.size = CGSize(width: .zero, height: 300)
        datePicker.preferredDatePickerStyle = .wheels

        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let minDate = formatter.date(from: "01.01.1930")
        let startDate = formatter.date(from: "15.06.1998")

        datePicker.maximumDate = Date()
        datePicker.minimumDate = minDate
        datePicker.date = startDate ?? Date()
        return datePicker
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

        birthdayTextField.inputView = datePicker
//        birthdayTextField.text = formatDate(date: Date()) // todays Date


//        birthdayTextField.keyboardType = .decimalPad
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
//            avatarImageView.heightAnchor.constraint(equalToConstant: 160),
//            avatarImageView.widthAnchor.constraint(equalToConstant: 160),

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

    @objc private func changeSex() {

    }
    @objc private func dateChange() {
        birthdayTextField.text = formatDate(date: datePicker.date)
    }

    @objc private func nextDidTap() {

        let runner = Runner(
            id: AuthManager.shared.currentUser?.uid ?? "---",
            phoneNumber: AuthManager.shared.currentUser?.phoneNumber ?? "---",
            nickname: nicknameTextField.text ?? "---",
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



    private func formatDate(date: Date) -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
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
        guard let text = textField.text else { return }
        if textField.tag == 0 {
            if text.count > 2 {
                nextButton.isEnabled = true
                nextButton.isSelected = false
            } else {
                nextButton.isEnabled = false
            }
        } else if textField.tag == 4, text.isEmpty {
            textField.text = "@"
        }
    }

    ///прокрутка контента
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {

        if textField.tag == 4 {
            if let text = textField.text, text.isEmpty {
                textField.text = "@"
            }
        }

        let bottom = -scrollView.contentInset.top + scrollView.contentSize.height - scrollView.frame.height
        scrollView.setContentOffset(CGPoint(x: .zero, y: bottom - (28 * (4 - CGFloat(textField.tag)))), animated: true)

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

        let screen = UIScreen.main.bounds.height
        let content = scrollView.contentSize.height
        if content > screen {
            let diff = (content - screen)// / screen
            let hidden = diff - scrollView.contentOffset.y
            let alpha = (diff - hidden) / diff

            if hidden > 0 && alpha > 0 {
                doneImageView.alpha = alpha
//                print(alpha)
            }
        }


    }
}
