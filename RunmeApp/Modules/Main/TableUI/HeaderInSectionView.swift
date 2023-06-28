//
//  HeaderInSectionView.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 28.06.2023.
//

import UIKit

final class HeaderInSectionView: UITableViewHeaderFooterView {

    static let reuseId = "HeaderInSectionView"

    private let leftLineView = UIView()
    private let rightLineView = UIView()

    private let titleLabel: LabelWithPadding = {
        let label = LabelWithPadding()
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.tintColor.cgColor
        label.layer.cornerRadius = 12
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()


    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        self.addSubview(titleLabel)
        let lines = [leftLineView, rightLineView]
        lines.forEach { line in
            line.layer.borderWidth = 1.5
            line.layer.borderColor = UIColor.tintColor.cgColor
            line.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(line)
        }


        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),

            leftLineView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            leftLineView.heightAnchor.constraint(equalToConstant: 2),
            leftLineView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            leftLineView.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -8),

            rightLineView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            rightLineView.heightAnchor.constraint(equalToConstant: 2),
            rightLineView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            rightLineView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
        ])
    }

    func fillHeader(date: String) {
        titleLabel.text = String(date.dropLast(10))
    }
    
}
