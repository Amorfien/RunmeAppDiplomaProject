//
//  AchievementsCollectionView.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 05.07.2023.
//

import UIKit

final class AchievementsCollectionView: UICollectionView {

    private let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        return layout
    }()

    init(delegate: UIViewController) {
        super.init(frame: .zero, collectionViewLayout: self.layout)
//        translatesAutoresizingMaskIntoConstraints = false
        self.delegate = delegate as? UICollectionViewDelegate
        self.dataSource = delegate as? UICollectionViewDataSource
        setupCollection()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCollection() {
        backgroundColor = Res.PRColors.prDark?.withAlphaComponent(0.9)
        layer.cornerRadius = 12
        register(UICollectionViewCell.self, forCellWithReuseIdentifier: "AchievementCell")
    }
    


}
