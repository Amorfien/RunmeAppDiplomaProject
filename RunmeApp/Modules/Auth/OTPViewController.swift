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
        phoneTextField.textPadding.left = 2 //костыль
        phoneTextField.attributedText = NSAttributedString(string: " ", attributes: [
            NSAttributedString.Key.kern: 10
        ])
        phoneTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }

    override func returnKeyButton(text: String) {
        var code = text
        code.removeFirst()
        AuthManager.shared.verifyCode(smsCode: code) { [weak self] success in
            guard success else { return }
            self?.viewModel.updateState(viewInput: .smsButtonDidTap)
        }
    }

    //ограничение количества символов, управление кнопкой
    override func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text.count == 7 {
            nextButton.isEnabled = true
            nextButton.isSelected = false
        } else if text.count > 1 && text.count < 7 {
            nextButton.isEnabled = false
        } else if text.count > 7{
            textField.deleteBackward()
        } else if text.count == 0 {
            phoneTextField.attributedText = NSAttributedString(string: " ", attributes: [
                NSAttributedString.Key.kern: 10
            ])
        }
    }

}
