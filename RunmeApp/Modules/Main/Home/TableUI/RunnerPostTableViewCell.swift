//
//  RunnerPostTableViewCell.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 03.07.2023.
//

import UIKit

final class RunnerPostTableViewCell: UITableViewCell {

    static let reuseId = "RunnerPostTableViewCell"

    // MARK: - Properties

    private let avatarImageView = AvatarCircleImageView(image: nil, size: .small)

    private let nicknameLabel = UILabel(text: "", font: .systemFont(ofSize: 20, weight: .bold), textColor: .tintColor, lines: 1)
    private let distanceLabel = UILabel(text: "", font: .systemFont(ofSize: 14, weight: .light), textColor: .secondaryLabel, lines: 1)

    private var descriptionText = UILabel(text: "", font: .systemFont(ofSize: 14, weight: .regular), textColor: .systemGray, lines: 2)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {

        backgroundColor = Res.PRColors.prLight

        [avatarImageView, nicknameLabel, distanceLabel, descriptionText].forEach(contentView.addSubview)

        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 100),

            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            nicknameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nicknameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            nicknameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            distanceLabel.leadingAnchor.constraint(equalTo: nicknameLabel.leadingAnchor),
            distanceLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 2),

            descriptionText.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 8),
            descriptionText.leadingAnchor.constraint(equalTo: nicknameLabel.leadingAnchor),
            descriptionText.trailingAnchor.constraint(equalTo: nicknameLabel.trailingAnchor),
        ])
    }


    // MARK: - Public method

    func fillData(with post: RunnerPost, indexPath: IndexPath) {
        nicknameLabel.text = post.author
        distanceLabel.text = "\(post.distance / 1000) км"
//        if let url = URL(string: article.urlToImage ?? "") {
//            let queue = DispatchQueue.global()
//            queue.async {
//                if let data = try? Data(contentsOf: url) {
//                    DispatchQueue.main.async {
//                        self.postImageView.image = UIImage(data: data)
//                    }
//                }
//
//            }
//        }
        descriptionText.text = post.text
    }


}
