//
//  PhoneViewController.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 24.06.2023.
//

import UIKit

class PhoneViewController: UIViewController {

    var coordinator: LoginCoordinator?

    lazy var phoneTextField: TextFieldWithPadding = {
        let phone = TextFieldWithPadding()
        phone.placeholder = "Phone number"
        phone.backgroundColor = .systemGray5
        phone.keyboardType = .numbersAndPunctuation
        phone.font = UIFont.systemFont(ofSize: 16)
        phone.textAlignment = .center
        phone.returnKeyType = .continue
        phone.delegate = self
        return phone
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground

        phoneTextField.frame = CGRect(x: 0, y: 0, width: 250, height: 44)
        phoneTextField.center = view.center
        view.addSubview(phoneTextField)
    }

    func returnKeyButton(text: String) {
        AuthManager.shared.startAuth(phoneNumber: text) { [weak self] success in
            guard success else { return }
            DispatchQueue.main.async {
                self?.coordinator?.pushOTPViewController()
            }
        }

    }


}

extension PhoneViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let text = phoneTextField.text, !text.isEmpty {
            returnKeyButton(text: text)
        }

        return true
    }
}
