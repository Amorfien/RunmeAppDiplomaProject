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

        self.handler = completion
        backgroundColor = .systemBackground

        contentMode = .scaleAspectFill

        if isEditable {
            isUserInteractionEnabled = true
            let button = UIButton(frame: CGRect(x: 0, y: size.rawValue - size.rawValue / 4
                                                , width: size.rawValue, height: size.rawValue / 4))
            button.backgroundColor = .white.withAlphaComponent(0.8)
            button.setTitle("➕", for: .normal)
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
//private lazy var avatarImageView: UIImageView = {
//    let imageView = UIImageView()
//    imageView.image = UIImage(named: "dafault-avatar")
//    imageView.contentMode = .scaleAspectFill
//    imageView.layer.cornerRadius = 80
//    imageView.layer.borderWidth = 1
//    imageView.clipsToBounds = true
//    imageView.isUserInteractionEnabled = true
//    imageView.translatesAutoresizingMaskIntoConstraints = false
//    let button = UIButton(frame: CGRect(x: 0, y: 120, width: 160, height: 40))
//    button.backgroundColor = .white.withAlphaComponent(0.8)
//    button.setTitle("➕", for: .normal)
//    button.addTarget(self, action: #selector(addButtonDidTap), for: .touchUpInside)
//    imageView.addSubview(button)
//    return imageView
//}()
