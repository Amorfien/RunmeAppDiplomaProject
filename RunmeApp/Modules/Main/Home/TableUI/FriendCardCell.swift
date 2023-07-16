//
//  FriendCardCell.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 28.06.2023.
//

import UIKit

final class FriendCardCell: UICollectionViewCell {

    static let id = "FriendCardCell"

    let circle = AvatarCircleImageView(image: UIImage(named: "dafault-avatar"), size: .middle)

    override var isSelected: Bool {
        didSet {
            layer.borderColor = isSelected ? UIColor.systemOrange.cgColor : #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
            layer.borderWidth = isSelected ? 2 : 0.5
        }
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup view

    private func setupView() {
        addSubview(circle)
        layer.borderWidth = 1
        layer.cornerRadius = circle.layer.cornerRadius
    }

    // MARK: - Public method

    func fillCardCell(avatar: UIImage) {
        circle.image = avatar
    }

}
