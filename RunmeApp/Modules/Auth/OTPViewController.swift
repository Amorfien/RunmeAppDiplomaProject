//
//  OTPViewController.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 24.06.2023.
//

import UIKit

class OTPViewController: PhoneViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .tertiarySystemBackground
        phoneTextField.placeholder = "SMS Code"
//        phoneTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
    }

    override func returnKeyButton(text: String) {
        AuthManager.shared.verifyCode(smsCode: text) { [weak self] success in
            guard success else { return }

            AuthManager.shared.searchUserInDb { [weak self] success in
                DispatchQueue.main.async {
                    success ? self?.coordinator?.pushToHome() : self?.coordinator?.pushRegistrationViewController()
                }
            }

//            DispatchQueue.main.async {
//                self?.coordinator?.pushToHome()
//            }

        }
    }

    override func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text.count == 6 {
            nextButton.isEnabled = true
            nextButton.isSelected = false
        } else if text.count < 6 {
            nextButton.isEnabled = false
        } else {
            textField.deleteBackward()
        }
    }

    override func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }


}
