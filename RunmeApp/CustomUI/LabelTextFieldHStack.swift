//
//  LabelTextFieldHStack.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 24.06.2023.
//

//import UIKit
//
//final class LabelTextFieldHStack: UIStackView {
//
//    enum RegisterLabel: String {
//        case name
//        case surname
//        case nickname
//        case birthday
//    }
//
//    private let label = UILabel()
//    private let textField = TextFieldWithPadding()
//
//    init(labelText: RegisterLabel) {
//        super.init(frame: .zero)
//        label.text = labelText.rawValue.capitalized + ":"
//        label.textAlignment = .right
//        setup()
//    }
//    
//    required init(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setup() {
//        self.addArrangedSubview(label)
//        self.addArrangedSubview(textField)
////        self.distribution = .fillProportionally
//        self.spacing = 12
//
//        textField.backgroundColor = .systemBackground
//        textField.layer.cornerRadius = 5
//        textField.layer.borderWidth = 0.5
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.heightAnchor.constraint(equalToConstant: 36).isActive = true
//        textField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7).isActive = true
//    }
//    
//}
