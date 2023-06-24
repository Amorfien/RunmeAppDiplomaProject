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
        case nickname
        case birthday
    }

    init(placeholder: RegisterLabel) {
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        layer.cornerRadius = 5
        layer.borderWidth = 0.5
        returnKeyType = .continue
        self.placeholder = placeholder.rawValue.capitalized
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 36).isActive = true
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
