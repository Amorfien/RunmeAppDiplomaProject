//
//  AuthBaseViewController.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 28.06.2023.
//

import UIKit

class PhoneVerificationViewController: UIViewController {

    enum VCType {
        case phone
        case sms
    }

    // MARK: - Properties
    private let viewModel: LoginViewModel

    private let type: VCType

    private lazy var topImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: self.type == .phone ? "phone" : "sms")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private lazy var phoneTextField: TextFieldWithPadding = {
        var phone = TextFieldWithPadding()
        phone.backgroundColor = .systemGray5
        phone.keyboardType = .phonePad
        if self.type == .phone {
            phone.attributedText = NSAttributedString(string: "+7", attributes: [
                NSAttributedString.Key.kern: 5
            ])
        } else {
            phone.textAlignment = .center
            phone.attributedText = NSAttributedString(string: " ", attributes: [
                NSAttributedString.Key.kern: 10
            ])
        }
        phone.font = .monospacedDigitSystemFont(ofSize: 26, weight: .medium)
        phone.layer.cornerRadius = 10
        phone.layer.borderColor = UIColor.lightGray.cgColor
        phone.layer.borderWidth = 0.5
        phone.translatesAutoresizingMaskIntoConstraints = false
        phone.delegate = self
        return phone
    }()

    private lazy var nextButton: LoginButton = {
        let button = LoginButton()
        button.setTitle("Далeе".uppercased(), for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(nextDidTap), for: .touchUpInside)
        return button
    }()

    private let termsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.text = "Нажимая кнопку \"Далее\" Вы принимаете пользовательское Соглашение и политику конфиденциальности"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var termsButton: UIButton = {
        let button = UIButton()
        button.setTitle("прочитать", for: .normal)
        button.setTitleColor(.tintColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .regular)
        button.addTarget(self, action: #selector(pushToTerms), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    //MARK: - Init

    init(viewModel: LoginViewModel, type: VCType) {
        self.viewModel = viewModel
        self.type = type
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
        view.addSubview(topImageView)
        view.addSubview(phoneTextField)
        view.addSubview(nextButton)

        NSLayoutConstraint.activate([
            topImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topImageView.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -80),
            topImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            topImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),

            phoneTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            phoneTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            phoneTextField.widthAnchor.constraint(equalToConstant: self.type == .phone ? 280 : 192),
            phoneTextField.heightAnchor.constraint(equalToConstant: 48),

            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 56),
            nextButton.heightAnchor.constraint(equalToConstant: 48),
            nextButton.widthAnchor.constraint(equalToConstant: 148),

        ])

        if self.type == .phone {
            view.addSubview(termsLabel)
            view.addSubview(termsButton)
            NSLayoutConstraint.activate([
                termsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                termsLabel.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 40),
                termsLabel.widthAnchor.constraint(equalTo: phoneTextField.widthAnchor),
                termsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                termsButton.topAnchor.constraint(equalTo: termsLabel.bottomAnchor),
//                termsLabel.widthAnchor.constraint(equalTo: phoneTextField.widthAnchor),
                ])
        }
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
    @objc private func pushToTerms() {
        viewModel.updateState(viewInput: .termsButtonDidTap)
    }

    func returnKeyButton(text: String) {
        switch type {

        case .phone:
            AuthManager.shared.startAuth(phoneNumber: text) { [weak self] success in
                guard success else { return }
                DispatchQueue.main.async {
                    self?.viewModel.updateState(viewInput: .phoneButtonDidTap)
                }
            }
        case .sms:
            var code = text
            code.removeFirst()
            AuthManager.shared.verifyCode(smsCode: code) { [weak self] success in
                guard success else { return }
                self?.viewModel.updateState(viewInput: .smsButtonDidTap)
            }
        }


    }


}

extension PhoneVerificationViewController: UITextFieldDelegate {

    // скрывать кнопку Next при пустых полях
    // ограничить количество символов
    func textFieldDidChangeSelection(_ textField: UITextField) {

        let maxChar = self.type == .phone ? 12 : 7
        let startChar = self.type == .phone ? "+" : " "
        let kern = self.type == .phone ? 5 : 10

        guard let text = textField.text else { return }
        if text.count == maxChar {
            nextButton.isEnabled = true
            nextButton.isSelected = false
        } else if text.count > 1 && text.count < maxChar {
            nextButton.isEnabled = false
        } else if text.count > maxChar {
            textField.deleteBackward()
        } else if text.count == 0 {
                    textField.attributedText = NSAttributedString(string: startChar, attributes: [
                        NSAttributedString.Key.kern: kern
                    ])
        }
    }

}

