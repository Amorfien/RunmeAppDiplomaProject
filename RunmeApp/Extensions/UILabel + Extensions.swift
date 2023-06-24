//
//  UILabel + Extensions.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 24.06.2023.
//

import UIKit

extension UILabel {

    convenience init(text: String, font: UIFont, textColor: UIColor) {
        self.init()

        self.text = text
        self.font = font
        self.textColor = textColor

        self.translatesAutoresizingMaskIntoConstraints = false
    }

}
