//
//  RegistrationViewController.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 24.06.2023.
//

import UIKit

final class RegistrationViewController: UIViewController {

    var coordinator: LoginCoordinator?

    private let registerLabel = UILabel(text: "Registration", font: .systemFont(ofSize: 22, weight: .semibold), textColor: .label)

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

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupGestures()
    }

    private func setupView() {
        view.backgroundColor = .systemGray5
        view.addSubview(registerLabel)
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
            registerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            registerLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 150),

            vStack.topAnchor.constraint(equalTo: registerLabel.bottomAnchor, constant: 40),
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

    @objc private func nextDidTap() {
        hideKeyboard()
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

}
