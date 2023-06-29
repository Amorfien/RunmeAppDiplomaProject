//
//  AvatarCircleView.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 29.06.2023.
//

import UIKit

final class AvatarCircleView: UIImageView {

    enum Size: CGFloat {
        case small = 80
        case middle = 160
        case large = 240
    }


    init(image: UIImage?, size: Size) {
        super.init(image: image)

        backgroundColor = .systemBackground
        layer.cornerRadius = size.rawValue / 2

        layer.borderWidth = size.rawValue / 80
        layer.borderColor = UIColor.tintColor.cgColor

        clipsToBounds = true

        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: size.rawValue).isActive = true
        widthAnchor.constraint(equalToConstant: size.rawValue).isActive = true

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
