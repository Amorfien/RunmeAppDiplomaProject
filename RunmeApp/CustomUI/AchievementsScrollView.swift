//
//  AchievementsScrollView.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 02.07.2023.
//

import UIKit

final class AchievementsScrollView: UIScrollView {


    override init(frame: CGRect) {//}, achievments: [String]) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        self.backgroundColor = .systemBackground.withAlphaComponent(0.25)
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.showsHorizontalScrollIndicator = false
        self.layer.borderWidth = 0.3
        self.layer.borderColor = UIColor.white.cgColor

    }

    func fillAchievements(with ach: Set<String>) {
        for (i, achievment) in ach.enumerated() {
            let imageView = UIImageView()
            imageView.frame = CGRect(x: 44 * i + 12, y: 8, width: 30, height: 30)
            imageView.contentMode = .scaleAspectFit
            if let image = UIImage(named: achievment) {
                imageView.image = image
            }  else {
                imageView.image = UIImage(systemName: "medal")
            }
            self.addSubview(imageView)
        }
        contentSize.width = CGFloat(ach.count * 44 + 12)
    }



}
