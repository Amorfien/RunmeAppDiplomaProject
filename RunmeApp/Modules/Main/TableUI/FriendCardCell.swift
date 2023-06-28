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
            backgroundColor = isSelected ? #colorLiteral(red: 0.1254901961, green: 0.3058823529, blue: 0.7803921569, alpha: 1) : .white
        }
    }



    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)

        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI
    private func setupView() {
        backgroundColor = .white

        layer.borderWidth = 1
        layer.borderColor = UIColor.tintColor.cgColor
        layer.cornerRadius = 30
    }

    private func setupConstraints() {

        NSLayoutConstraint.activate([


        ])
    }

    // MARK: - public method
    func fillCardCell() {

    }

}
