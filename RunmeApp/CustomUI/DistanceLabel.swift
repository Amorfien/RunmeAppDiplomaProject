//
//  DistanceLabel.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 02.07.2023.
//

import UIKit

final class DistanceLabel: LabelWithPadding {

    enum Distance: String {
        case five = "5 км"
        case ten = "10 км"
        case twenty = "21.0975"
        case forty = "МАРАФОН"
    }

    init(type: Distance) {
        super.init(frame: .zero)
        backgroundColor = .systemBackground.withAlphaComponent(0.25)
        font = .monospacedDigitSystemFont(ofSize: 16, weight: .medium)
//        layer.masksToBounds = true
        clipsToBounds = true
        layer.cornerRadius = 18
        layer.borderWidth = 0.1
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 36).isActive = true

        let rightLabel = UILabel(text: type.rawValue, font: .systemFont(ofSize: 14, weight: .light), textColor: .secondaryLabel, lines: 1)
        rightLabel.textAlignment = .center
        rightLabel.translatesAutoresizingMaskIntoConstraints = true
        rightLabel.frame = CGRect(x: 132, y: 10, width: 100, height: 20)

        addSubview(rightLabel)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }




}
