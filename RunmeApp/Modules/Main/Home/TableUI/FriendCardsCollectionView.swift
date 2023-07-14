//
//  FriendCardsCollectionView.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 28.06.2023.
//

import UIKit

protocol UsersTableHeaderDelegate: AnyObject {
    func chooseUser(id: String)
}

final class FriendCardsCollectionView: UICollectionView {

    weak var headerDelegate: UsersTableHeaderDelegate?

    private var users: [String] = [] {
        didSet {
                self.reloadData()
        }
    }
    private var images: [UIImage] = [] {
        didSet {
                self.reloadData()
        }
    }

    private var selectedItem: IndexPath?

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
        backgroundColor = Res.PRColors.prLight
        showsHorizontalScrollIndicator = false
//        let separator = UIView(frame: CGRect(x: 0, y: 119, width: UIScreen.main.bounds.width / 3, height: 1))
//        separator.backgroundColor = tintColor
//
//        addSubview(separator)

    }

    // MARK: - public method
    func fillCardsCollection(users: [String], images: [UIImage]) {
            self.users = users
            self.images = images
    }

}

// MARK: - setup collectionview
extension FriendCardsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendCardCell.id, for: indexPath) as? FriendCardCell {
           
            let avatar = images[indexPath.item]
            cell.fillCardCell(avatar: avatar)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}
extension FriendCardsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 100, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath == selectedItem {
            headerDelegate?.chooseUser(id: "0")
            collectionView.deselectItem(at: indexPath, animated: false)
            selectedItem = nil
        } else {
            headerDelegate?.chooseUser(id: users[indexPath.row])
            selectedItem = indexPath
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}
