//
//  CustomTextField.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 24.06.2023.
//

import UIKit

final class RegistrationTextField: TextFieldWithPadding {

    enum RegisterLabel: String {
        case nickname = "Никнейм (обязательно)"
        case name = "Имя"
        case surname = "Фамилия"
        case telegram = "Telegram"
        case email = "E-mail"
        case birthday = "День рождения"
        case status = "Статус"

        case five = "5 км"
        case ten = "10 км"
        case twenty = "21 км"
        case forty = "42 км"

        var placeholder: String {
            switch self {
            case .nickname:
                return "Молния"
            case .name:
                return "Саша"
            case .surname:
                return "Сова"
            case .birthday:
                return "22.10.1998"
            case .telegram:
                return "@telegram"
            case .email:
                return "адрес@почта.бег"
            case .status:
                return "бегу..."
            default:
                return ""
            }
        }
    }

    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChange), for: UIControl.Event.valueChanged)
        datePicker.frame.size = CGSize(width: .zero, height: 300)
        datePicker.preferredDatePickerStyle = .wheels

        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let minDate = formatter.date(from: "01.01.1930")
        datePicker.maximumDate = Date()
        datePicker.minimumDate = minDate
        return datePicker
    }()
//    lazy var timePicker: UIDatePicker = {
//        let timePicker = UIDatePicker()
//        timePicker.datePickerMode = .time
//        timePicker.preferredDatePickerStyle = .wheels
//        timePicker.addTarget(self, action: #selector(timeChange), for: UIControl.Event.valueChanged)
////        timePicker.frame.size = CGSize(width: .zero, height: 300)
////        timePicker.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
////        timePicker.locale = .current
//
//        let formatter = DateFormatter()
//        formatter.timeStyle = .medium
//        formatter.dateStyle = .none
//        formatter.dateFormat = "HH:mm:ss"
//
//        timePicker.date = Date()
//
//        return timePicker
//    }()

    init(type: RegisterLabel) {
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        layer.cornerRadius = 5
        layer.borderWidth = 0.5
        returnKeyType = .continue
        self.placeholder = type.placeholder
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 36).isActive = true

        switch type {
        case .nickname:
            tag = 0
        case .name:
            tag = 1
        case .surname:
            tag = 2
        case .telegram:
            tag = 3
        case .email:
            tag = 4
        case .birthday:
            tag = 5
            inputView = datePicker
            font = .monospacedDigitSystemFont(ofSize: 16, weight: .regular)
            widthAnchor.constraint(equalToConstant: 120).isActive = true
        case .status:
            tag = 7
        case .five:
            tag = 9
            inputView = UIView()
            font = .monospacedDigitSystemFont(ofSize: 14, weight: .regular)
        case .ten:
            tag = 10
            inputView = UIView()
            font = .monospacedDigitSystemFont(ofSize: 14, weight: .regular)
        case .twenty:
            tag = 20
            inputView = UIView()
            font = .monospacedDigitSystemFont(ofSize: 14, weight: .regular)
        case .forty:
            tag = 40
            inputView = UIView()
            font = .monospacedDigitSystemFont(ofSize: 14, weight: .regular)
        }

//        if type == .birthday {
//            inputView = datePicker
//            font = .monospacedDigitSystemFont(ofSize: 16, weight: .regular)
//            widthAnchor.constraint(equalToConstant: 120).isActive = true
//        }

//        if type == .five {//}, type == .ten, type == .twenty, type == .forty {
//            inputView = timePicker
//        }
//        if type == .forty {}

        let topLabel = UILabel(text: type.rawValue, font: .systemFont(ofSize: 12, weight: .light), textColor: .secondaryLabel, lines: 1)
        topLabel.translatesAutoresizingMaskIntoConstraints = true
        topLabel.frame = CGRect(x: 10, y: -20, width: 150, height: 20)

        addSubview(topLabel)

        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func dateChange() {
            text = birthdayDateToString(date: datePicker.date)
    }
//    @objc private func timeChange() {
//            text = timeDateToString(date: timePicker.date)
//    }

    
}
