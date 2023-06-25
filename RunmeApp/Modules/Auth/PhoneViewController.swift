//
//  PhoneViewController.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 24.06.2023.
//

import UIKit

class PhoneViewController: UIViewController {

    // MARK: - Properties
    let viewModel: LoginViewModel

    lazy var phoneTextField: TextFieldWithPadding = {
        var phone = TextFieldWithPadding()
        phone.backgroundColor = .systemGray5
        phone.keyboardType = .phonePad
        phone.attributedText = NSAttributedString(string: "+7", attributes: [
            NSAttributedString.Key.kern: 5
        ])
        phone.font = UIFont(name: "Menlo-Regular", size: 26)
        phone.layer.cornerRadius = 10
        phone.layer.borderColor = UIColor.lightGray.cgColor
        phone.layer.borderWidth = 0.5
        phone.translatesAutoresizingMaskIntoConstraints = false
        phone.delegate = self
        return phone
    }()

    lazy var nextButton: LoginButton = {
        let button = LoginButton()
        button.setTitle("Next", for: .normal)
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        phoneTextField.becomeFirstResponder()
    }

    // MARK: - Private methods

    private func setupView() {
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(phoneTextField)
        view.addSubview(nextButton)

        NSLayoutConstraint.activate([
            phoneTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            phoneTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80),
            phoneTextField.widthAnchor.constraint(equalToConstant: 272),
            phoneTextField.heightAnchor.constraint(equalToConstant: 48),

            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 56),
//            nextButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -50),
            nextButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }

    // MARK: - Actions

    @objc private func nextDidTap() {
        if let text = phoneTextField.text, !text.isEmpty {
            returnKeyButton(text: text)
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

    func returnKeyButton(text: String) {
        AuthManager.shared.startAuth(phoneNumber: text) { [weak self] success in
            guard success else { return }
            DispatchQueue.main.async {
                self?.viewModel.updateState(viewInput: .phoneButtonDidTap)
            }
        }

    }


}

extension PhoneViewController: UITextFieldDelegate {

    // скрывать кнопку Next при пустых полях
    // ограничить количество символов
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text.count == 12 {
            nextButton.isEnabled = true
            nextButton.isSelected = false
        } else if text.count > 1 && text.count < 12 {
            nextButton.isEnabled = false
        } else if text.count > 12 {
            textField.deleteBackward()
        } else if text.count == 0 {
                    textField.attributedText = NSAttributedString(string: "+", attributes: [
                        NSAttributedString.Key.kern: 5
                    ])
        }
    }

}
