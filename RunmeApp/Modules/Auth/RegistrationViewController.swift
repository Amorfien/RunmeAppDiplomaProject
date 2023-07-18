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

    private lazy var registrationView = RegistrationView(delegate: self)

    //MARK: - Init

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        print(#function, " RegistrationViewController 📱")
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Регистрация".localized
        view.backgroundColor = .systemGray5
        view.addSubview(registrationView)
        registrationView.frame = self.view.frame
        viewModel.updateState(viewInput: .registerOrSettings) //проверяем начальный стейт чтобы сработал дидсет
    }

    deinit {
        print(#function, " RegistrationViewController 📱")
    }

}

//MARK: - Extensions

extension RegistrationViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0: registrationView.nameTextField.becomeFirstResponder()
        case 1: registrationView.surnameTextField.becomeFirstResponder()
        case 2: registrationView.emailTextField.becomeFirstResponder()
        case 3: registrationView.telegramTextField.becomeFirstResponder()
        case 4: registrationView.birthdayTextField.becomeFirstResponder()
        default: registrationView.hideKeyboard()
        }
        return true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if textField.tag == 0 {
            if text.count > 2 {
                registrationView.nextButton.isEnabled = true
                registrationView.nextButton.isSelected = false
            } else {
                registrationView.nextButton.isEnabled = false
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

        let bottom = -registrationView.scrollView.contentInset.top + registrationView.scrollView.contentSize.height - registrationView.scrollView.frame.height
        registrationView.scrollView.setContentOffset(CGPoint(x: .zero, y: bottom - (28 * (4 - CGFloat(textField.tag)))), animated: true)

        return true
    }

}

extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            registrationView.avatarImageView.image = pickedImage
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
                registrationView.doneImageView.alpha = alpha
            }
        }
    }
}
