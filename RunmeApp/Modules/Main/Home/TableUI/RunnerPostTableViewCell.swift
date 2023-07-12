//
//  RunnerPostTableViewCell.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 03.07.2023.
//

import UIKit

protocol PostTableCellDelegate: AnyObject {
    func likeDidTap(postId: String)
    func deleteDidTap(postId: String)
}

final class RunnerPostTableViewCell: UITableViewCell {

    static let reuseId = "RunnerPostTableViewCell"

    // MARK: - Properties

    weak var cellDelegate: PostTableCellDelegate?

    private let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground

        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.tintColor.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let avatarImageView = AvatarCircleImageView(image: nil, size: .small)
    private let nicknameLabel = UILabel(text: "", font: .systemFont(ofSize: 16, weight: .bold), textColor: .tintColor, lines: 1)
    private let distanceLabel = UILabel(text: "", font: .systemFont(ofSize: 14, weight: .light), textColor: .label, lines: 1)
    private let timeLabel = UILabel(text: "", font: .monospacedDigitSystemFont(ofSize: 14, weight: .light), textColor: .label, lines: 1)
    private let tempLabel = UILabel(text: "", font: .monospacedDigitSystemFont(ofSize: 14, weight: .thin), textColor: .label, lines: 1)
    private let dateLabel = UILabel(text: "", font: .systemFont(ofSize: 11, weight: .light), textColor: .secondaryLabel, lines: 1)

    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setTitle("0 🩶", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .light)
        button.contentHorizontalAlignment = .right
        button.setTitleColor(.label, for: .normal)
        button.addTarget(self, action: #selector(likeTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var delButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "multiply"), for: .normal)
        button.addTarget(self, action: #selector(delTap), for: .touchUpInside)
        button.isHidden = true
        button.layer.cornerRadius = 14
        button.layer.borderWidth = 1
        button.backgroundColor = Res.PRColors.prLight
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var itsme: Bool = false
    private var postId: String = ""

    private var descriptionText = UILabel(text: "", font: .systemFont(ofSize: 14, weight: .regular), textColor: .secondaryLabel, lines: 2)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {

        backgroundColor = Res.PRColors.prLight
        tempLabel.textAlignment = .right

        let selectedView = UIView()
        selectedView.backgroundColor = Res.PRColors.prMedium
        selectedBackgroundView = selectedView

        contentView.addSubview(bgView)
        [avatarImageView, nicknameLabel, distanceLabel, descriptionText, timeLabel, tempLabel, dateLabel, likeButton].forEach(bgView.addSubview)
        contentView.addSubview(delButton)

        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 116),

            bgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            bgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            bgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            bgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

//            avatarImageView.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            avatarImageView.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 10),
            avatarImageView.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 10),

            nicknameLabel.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 8),
            nicknameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 14),
            nicknameLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -80),

            likeButton.topAnchor.constraint(equalTo: bgView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -12),
            likeButton.widthAnchor.constraint(equalToConstant: 80),
            likeButton.heightAnchor.constraint(equalToConstant: 30),
            delButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            delButton.centerYAnchor.constraint(equalTo: bgView.topAnchor, constant: 6),
            delButton.widthAnchor.constraint(equalToConstant: 28),
            delButton.heightAnchor.constraint(equalToConstant: 28),

            distanceLabel.leadingAnchor.constraint(equalTo: nicknameLabel.leadingAnchor),
            distanceLabel.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -6),
            timeLabel.bottomAnchor.constraint(equalTo: distanceLabel.bottomAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 76),
            tempLabel.bottomAnchor.constraint(equalTo: distanceLabel.bottomAnchor),
            tempLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -12),
            dateLabel.centerXAnchor.constraint(equalTo: avatarImageView.centerXAnchor),
            dateLabel.topAnchor.constraint(equalTo: distanceLabel.topAnchor),

            descriptionText.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 4),
            descriptionText.leadingAnchor.constraint(equalTo: nicknameLabel.leadingAnchor),
            descriptionText.trailingAnchor.constraint(equalTo: tempLabel.trailingAnchor),
            descriptionText.bottomAnchor.constraint(equalTo: distanceLabel.topAnchor, constant: -4)
        ])
    }

    // MARK: - Public method

    func fillData(with post: RunnerPost, avatar: UIImage, iLikeIt: Bool = false, itsme: Bool = false) {
        avatarImageView.image = avatar
        nicknameLabel.text = post.userNickname
        let meters = post.distance / 1000
        let kmeters = round(meters * 100) / 100
        distanceLabel.text = "\(kmeters) км"
        timeLabel.text = timeFormat(sec: Int(post.time), seconds: false)
        tempLabel.text = tempFormat(sec: Int(post.temp)) + " мин/км"
        dateLabel.text = post.date
        descriptionText.text = post.text
        let buttonText = String(post.likes.count) + (iLikeIt ? " ♥️" : " 🩶")
        likeButton.setTitle(buttonText, for: .normal)
        delButton.isHidden = !itsme
        self.itsme = itsme
        self.postId = post.postId //для поиска лайкнутого/удаленного поста
    }

    @objc private func likeTap() {
        cellDelegate?.likeDidTap(postId: postId)
    }
    @objc private func delTap() {
        delButton.backgroundColor = Res.PRColors.prMedium
        cellDelegate?.deleteDidTap(postId: postId)
    }

}
