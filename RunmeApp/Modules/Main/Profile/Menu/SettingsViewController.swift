//
//  SettingsViewController.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 05.07.2023.
//

import UIKit

protocol SettingsDelegate: AnyObject {
    func userUpdate()
}

final class SettingsViewController: UIViewController {

    weak var delegate: SettingsDelegate?
    let viewModel: ProfileViewModel

    private lazy var settingsView = RegistrationView(delegate: self)

    private lazy var birthdaySwitch: UISwitch = {
        let bdSwitch = UISwitch()
        bdSwitch.addTarget(self, action: #selector(showBirthday), for: .valueChanged)
        bdSwitch.translatesAutoresizingMaskIntoConstraints = false
        return bdSwitch
    }()
    private let birthdayLabel = UILabel(text: "показывать дату моего рождения", font: .systemFont(ofSize: 14), textColor: .secondaryLabel, lines: 1)

    let fiveTextField = RegistrationTextField(type: .five)
    let tenTextField = RegistrationTextField(type: .ten)
    let twentyTextField = RegistrationTextField(type: .twenty)
    let fortyTextField = RegistrationTextField(type: .forty)
    private lazy var runtimeViews = [fiveTextField, tenTextField, twentyTextField, fortyTextField]

    private var runtime: [Int] = [0, 0, 0] {
        didSet {
//            print(runtime)
//            fiveTextField.text = "\(runtime[0]) \(runtime[1]) \(runtime[2])"
            runtimeViews.forEach { textfield in
                if textfield.isFirstResponder {
                    textfield.text = "\(runtime[0]) ч \(runtime[1]) мин \(runtime[2]) с"
//                    print(timeStringFormat(string: textfield.text ?? ""))
                    let seconds = runtime[0] * 3600 + runtime[1] * 60 + runtime[2]
                    switch textfield.tag {
                    case 9:
                        fiveBest = seconds
                    case 10:
                        tenBest = seconds
                    case 20:
                        twentyBest = seconds
                    case 40:
                        fortyBest = seconds
                    default:
                        break
                    }
                }
            }
        }
    }
    private var fiveBest: Int = 0
    private var tenBest: Int = 0
    private var twentyBest: Int = 0
    private var fortyBest: Int = 0
    private lazy var bests = [fiveBest, tenBest, twentyBest, fortyBest]

    lazy var timePickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.isHidden = true
        picker.backgroundColor = .white.withAlphaComponent(0.98)
        picker.layer.cornerRadius = 10
        picker.layer.borderWidth = 0.5

        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()


    //MARK: - Init

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        let strDate = viewModel.fetchedUser?.birthday ?? ""

        settingsView.birthdayTextField.datePicker.date = view.birthdayStringToDate(string: strDate) ?? Date()
        print(#function, " RegistrationViewController 📱")

        fiveTextField.delegate = self
        tenTextField.delegate = self
        twentyTextField.delegate = self
        fortyTextField.delegate = self
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        settingsView.settingsScreen(profile: viewModel.fetchedUser)
        setupView()
        setupGestures()
        fillRuntime()

    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        updateUser()
        delegate?.userUpdate()
    }

    deinit {
        print(#function, " SettingsViewController 📱")
    }


    private func setupView() {
        view.backgroundColor = .systemGray5
        view.addSubview(settingsView)
        view.addSubview(birthdaySwitch)
        view.addSubview(birthdayLabel)
        view.addSubview(fiveTextField)
        view.addSubview(tenTextField)
        view.addSubview(twentyTextField)
        view.addSubview(fortyTextField)
        view.addSubview(timePickerView)

        birthdaySwitch.isOn = viewModel.fetchedUser?.birthdayShow ?? true
//        print(viewModel.fetchedUser?.birthdayShow)
        settingsView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            settingsView.topAnchor.constraint(equalTo: view.topAnchor),
            settingsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            settingsView.heightAnchor.constraint(equalToConstant: 420),

            birthdaySwitch.topAnchor.constraint(equalTo: settingsView.bottomAnchor, constant: -4),
            birthdaySwitch.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            birthdayLabel.centerYAnchor.constraint(equalTo: birthdaySwitch.centerYAnchor),
            birthdayLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48),

            fiveTextField.topAnchor.constraint(equalTo: birthdayLabel.bottomAnchor, constant: 36),
            fiveTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            fiveTextField.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -4),
            tenTextField.topAnchor.constraint(equalTo: fiveTextField.topAnchor),
            tenTextField.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 4),
            tenTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),

            twentyTextField.topAnchor.constraint(equalTo: fiveTextField.bottomAnchor, constant: 28),
            twentyTextField.leadingAnchor.constraint(equalTo: fiveTextField.leadingAnchor),
            twentyTextField.trailingAnchor.constraint(equalTo: fiveTextField.trailingAnchor),
            fortyTextField.topAnchor.constraint(equalTo: twentyTextField.topAnchor),
            fortyTextField.leadingAnchor.constraint(equalTo: tenTextField.leadingAnchor),
            fortyTextField.trailingAnchor.constraint(equalTo: tenTextField.trailingAnchor),

            timePickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timePickerView.bottomAnchor.constraint(equalTo: fiveTextField.topAnchor, constant: -20),
            timePickerView.widthAnchor.constraint(equalToConstant: 280),
            timePickerView.heightAnchor.constraint(equalToConstant: 150),
            ])
    }

    @objc private func showBirthday(_ sender: UISwitch) {
        viewModel.fetchedUser?.birthdayShow = sender.isOn
    }

    //  жест чтобы скрывать клавиатуру по тапу
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    @objc func hideKeyboard() {
        view.endEditing(true)
    }

    private func fillRuntime() {
        runtimeViews.enumerated().forEach { (i, tf) in
            tf.text = view.timeFormat(sec: viewModel.fetchedUser?.personalBests[i],
                                 isMale: viewModel.fetchedUser?.isMale)
        }
    }
    private func updateUser() {

        var user = settingsView.updateUser()
        user.birthdayShow = birthdaySwitch.isOn

        bests.enumerated().forEach { (i, best) in
                user.personalBests[i] = best
        }

        viewModel.updateState(viewInput: .updateUser(user))
    }

    
}


//extension SettingsViewController: UIScrollViewDelegate {}

extension SettingsViewController: UITextFieldDelegate {
    

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 9 || textField.tag == 10 || textField.tag == 20 || textField.tag == 40 {
//            textField.inputView = UIView()
//            textField.inputAccessoryView = UIView()
            textField.text = ""
            timePickerView.isHidden = false
//            print(textField.tag)
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        timePickerView.isHidden = true
    }

}

extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 5
        case 1, 2:
            return 60
        default:
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(row) ч"
        case 1:
            return "\(row) мин"
        case 2:
            return "\(row) с"
        default:
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        runtime[component] = row
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch component {
        case 0:
            return pickerView.frame.size.width * 2 / 8
        case 1:
            return pickerView.frame.size.width * 3 / 8
        case 2:
            return pickerView.frame.size.width * 3 / 8
        default:
            return 0
        }
    }

}
