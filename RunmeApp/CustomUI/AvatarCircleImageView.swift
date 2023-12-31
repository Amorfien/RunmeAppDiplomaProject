//
//  AvatarCircleImageView.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 29.06.2023.
//

import UIKit

final class AvatarCircleImageView: UIImageView {

    enum Size: CGFloat {
        case small = 60
        case middle = 100
        case large = 160
        case xLarge = 240
    }

    private var handler: (() -> Void)?

    init(image: UIImage?, size: Size, isEditable: Bool = false, completion: (() -> Void)? = nil) {
        super.init(image: image)

        if image == nil {
            self.image = UIImage(named: "dafault-avatar")!
        }

        self.handler = completion
        backgroundColor = .tintColor
        contentMode = .scaleAspectFill
        isUserInteractionEnabled = true
        if isEditable {
            let button = UIButton(frame: CGRect(x: 0, y: size.rawValue - size.rawValue / 4
                                                , width: size.rawValue, height: size.rawValue / 4))
            button.backgroundColor = .white.withAlphaComponent(0.8)
            button.setTitle("🔄", for: .normal)
            button.addTarget(self, action: #selector(addButtonDidTap), for: .touchUpInside)
            addSubview(button)
        }

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

    @objc func addButtonDidTap() {
        handler!()
    }

}

