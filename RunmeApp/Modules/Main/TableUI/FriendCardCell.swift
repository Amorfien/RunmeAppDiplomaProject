//
//  FriendCardCell.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 28.06.2023.
//

import UIKit

final class FriendCardCell: UICollectionViewCell {

    static let id = "FriendCardCell"

    override var isSelected: Bool {
        didSet {
            layer.borderColor = isSelected ? UIColor.systemOrange.cgColor : #colorLiteral(red: 0.1254901961, green: 0.3058823529, blue: 0.7803921569, alpha: 1)
            layer.borderWidth = isSelected ? 2 : 1
        }
    }



    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)

        setupView()
//        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI
    private func setupView() {
        let circle = AvatarCircleView(image: UIImage(named: "dafault-avatar"), size: .small)
        addSubview(circle)
//        self = AvatarCircleView(image: UIImage(named: "dafault-avatar"), size: .small)
//        backgroundColor = .white//Res.MyColors.homeBackground
//
        layer.borderWidth = 1
//        layer.borderColor = UIColor.red.cgColor
        layer.cornerRadius = circle.layer.cornerRadius
    }

    private func setupConstraints() {

        NSLayoutConstraint.activate([


        ])
    }

    // MARK: - public method
    func fillCardCell() {

    }

}
