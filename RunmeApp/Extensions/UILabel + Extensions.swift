//
//  UILabel + Extensions.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 24.06.2023.
//

import UIKit

extension UILabel {

    convenience init(text: String, font: UIFont, textColor: UIColor, lines: Int) {
        self.init()

        self.text = text
        self.font = font
        self.textColor = textColor
        self.numberOfLines = lines
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.8

        self.translatesAutoresizingMaskIntoConstraints = false
    }

}
