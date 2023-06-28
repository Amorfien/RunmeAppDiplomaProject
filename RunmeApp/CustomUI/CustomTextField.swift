//
//  CustomTextField.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 24.06.2023.
//

import UIKit

final class CustomTextField: TextFieldWithPadding {

    enum RegisterLabel: String {
        case nickname = "Никнейм (обязательно)"
        case name = "Имя"
        case surname = "Фамилия"
        case telegram = "Telegram"
        case email = "E-mail"
        case birthday = "День рождения"

        var placeholder: String {
            switch self {
            case .nickname:
                return "Flash"
            case .name:
                return "Саша"
            case .surname:
                return "Филин"
            case .birthday:
                return "22.10.98"
            case .telegram:
                return "@telegram"
            case .email:
                return "собака@почта.ру"
//            default:
//                return ""
            }
        }
    }

    init(type: RegisterLabel) {
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        layer.cornerRadius = 5
        layer.borderWidth = 0.5
        returnKeyType = .continue
        self.placeholder = type.placeholder
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 36).isActive = true

        let topLabel = UILabel(text: type.rawValue, font: .systemFont(ofSize: 12, weight: .light), textColor: .secondaryLabel)
        topLabel.translatesAutoresizingMaskIntoConstraints = true
        topLabel.frame = CGRect(x: 16, y: -20, width: 150, height: 20)

        addSubview(topLabel)

        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
