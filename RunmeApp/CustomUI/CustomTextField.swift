//
//  CustomTextField.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 24.06.2023.
//

import UIKit

final class CustomTextField: TextFieldWithPadding {

    enum RegisterLabel: String {
        case name
        case surname
        case nickname = "Nickname (required)"
        case telegram
        case email
        case birthday

        var placeholder: String {
            switch self {
            case .name:
                return "John"
            case .surname:
                return "Black"
            case .nickname:
                return "Flash"
            case .birthday:
                return "22.10.98"
            case .telegram:
                return "@telegram"
            case .email:
                return "flashjohn@aol.com"
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
        translatesAutoresizingMaskIntoConstraints = false

        let topLabel = UILabel(text: type.rawValue.capitalized, font: .systemFont(ofSize: 12, weight: .light), textColor: .secondaryLabel)
        topLabel.translatesAutoresizingMaskIntoConstraints = true
        topLabel.frame = CGRect(x: 16, y: -20, width: 200, height: 20)

        addSubview(topLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
