//
//  RegistrationView.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 05.07.2023.
//

import UIKit

final class RegistrationView: UIView {

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        scrollView.delegate = delegate as? UIScrollViewDelegate
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    lazy var avatarImageView = AvatarCircleImageView(
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

    let nicknameTextField = RegistrationTextField(type: .nickname)
    let nameTextField = RegistrationTextField(type: .name)
    let surnameTextField = RegistrationTextField(type: .surname)
    let emailTextField = RegistrationTextField(type: .email)
    let telegramTextField = RegistrationTextField(type: .telegram)
    let hStack = UIStackView()
    let birthdayTextField = RegistrationTextField(type: .birthday)

    private lazy var sexSegment: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Муж", "Жен"])
        segmentedControl.selectedSegmentTintColor = .tintColor
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(changeSex), for: .valueChanged)
        return segmentedControl
    }()

    let doneImageView: UIImageView = {
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

    private lazy var vStackConstraint = vStack.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 48)
    private lazy var buttonConstraint = nextButton.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor, constant: -12)


    lazy var nextButton: LoginButton = {
        let button = LoginButton()
        button.setTitle("Готово", for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(nextDidTap), for: .touchUpInside)
        return button
    }()

    weak var delegate: UIViewController?
    private var isSettings: Bool = false

    //MARK: - Init

    init(delegate: UIViewController, isSettings: Bool = false) {
        super.init(frame: .zero)
        self.delegate = delegate
        self.isSettings = isSettings
        setupView()
        setupGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print(#function, " RegistrationView 📺")
    }


    private func setupView() {
//        self.title = "Регистрация"
        backgroundColor = .systemGray5
        addSubview(scrollView)
        scrollView.addSubview(avatarImageView)
        scrollView.addSubview(vStack)
        scrollView.addSubview(doneImageView)
        let textFields = [nicknameTextField, nameTextField, surnameTextField, emailTextField, telegramTextField, birthdayTextField]

        for (tag, textField) in textFields.enumerated() {
            if textField != birthdayTextField {
                vStack.addArrangedSubview(textField)
            }
            textField.delegate = delegate as? UITextFieldDelegate
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

        addSubview(nextButton)

        NSLayoutConstraint.activate([

            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),

            avatarImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24),
            avatarImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
//            avatarImageView.heightAnchor.constraint(equalToConstant: 160),
//            avatarImageView.widthAnchor.constraint(equalToConstant: 160),

            vStackConstraint,
            vStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            vStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
//            vStack.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -220),

            doneImageView.topAnchor.constraint(equalTo: vStack.bottomAnchor, constant: 32),
            doneImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: -32),
            doneImageView.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.contentLayoutGuide.bottomAnchor, constant: 0),
            doneImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.65),
            doneImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.65),

            buttonConstraint,
            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            nextButton.widthAnchor.constraint(equalToConstant: 150),

        ])
    }


    func settingsScreen(profile: Runner?) {
        nextButton.isHidden = true
        avatarImageView.isHidden = true
        buttonConstraint.isActive = false
        vStackConstraint.isActive = false
        vStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 48).isActive = true
        vStack.spacing = 28
        scrollView.isScrollEnabled = false
        nicknameTextField.isEnabled = false
        nicknameTextField.text = profile?.nickname
        nicknameTextField.alpha = 0.5
        nameTextField.text = profile?.name
        surnameTextField.text = profile?.surname
        emailTextField.text = profile?.email
        telegramTextField.text = profile?.telegram
        birthdayTextField.text = profile?.birthday
        sexSegment.selectedSegmentIndex = (profile?.isMale ?? true) ? 0 : 1
        sexSegment.isEnabled = false
    }


    // MARK: - Actions

    @objc private func addButtonDidTap() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = delegate as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        delegate?.present(imagePicker, animated: true)
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

        (delegate as? RegistrationViewController)?.viewModel.updateState(viewInput: .registerButtonDidTap(runner))

    }

    func updateUser() {

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

        (delegate as? SettingsViewController)?.viewModel.updateState(viewInput: .saveUser(runner))

    }

    //  жест чтобы скрывать клавиатуру по тапу
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        addGestureRecognizer(tapGesture)
    }
    @objc func hideKeyboard() {
        endEditing(true)
    }



    private func formatDate(date: Date) -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }

}
    
