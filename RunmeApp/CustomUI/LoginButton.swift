//
//  LoginButton.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 23.06.2023.
//

import UIKit

final class LoginButton: UIButton {

    override var isSelected: Bool {
        didSet {
            alpha = isSelected ? 0.4 : 1.0
        }
    }

    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .darkGray : .tintColor
        }
    }

    override var isEnabled: Bool {
        didSet {
            alpha = isHighlighted ? 1.0 : 0.4
        }
    }

    init() {
        super.init(frame: .zero)
        backgroundColor = .tintColor
        titleLabel?.textColor = .white
        layer.cornerRadius = 8
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 5
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
