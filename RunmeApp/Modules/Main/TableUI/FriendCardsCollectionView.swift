//
//  FriendCardsCollectionView.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 28.06.2023.
//

import UIKit

final class FriendCardsCollectionView: UICollectionView {

    private var avatars: [UIImage] = [] {
        didSet {
                self.reloadData()
        }
    }

    private let weatherCardsLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        return layout
    }()

    // MARK: - Init
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: weatherCardsLayout)
        register(FriendCardCell.self, forCellWithReuseIdentifier: FriendCardCell.id)
        setupView()

        dataSource = self
        delegate = self
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = Res.MyColors.homeBackground
        showsHorizontalScrollIndicator = false
//        self.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            self.heightAnchor.constraint(equalToConstant: 100),
//            self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
//        ])
    }

    // MARK: - public method
    func fillCardsCollection(avatars: [UIImage]) {
        self.avatars = avatars
    }

}

// MARK: - setup collectionview
extension FriendCardsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        avatars.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendCardCell.id, for: indexPath) as? FriendCardCell {
           
            let avatar = avatars[indexPath.item]
            cell.fillCardCell(avatar: avatar)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}
extension FriendCardsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 80, height: 80)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
