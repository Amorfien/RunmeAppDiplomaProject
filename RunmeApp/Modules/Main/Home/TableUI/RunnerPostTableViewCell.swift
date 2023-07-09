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

    private let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground

        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.tintColor.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
//    let author: String
//    let date: String
//    let text: String
//    let distance: Int
//    let time: Int
//    var temp: Double {
//        Double(time / distance)
//    }
//    var likes = 0
    private let avatarImageView = AvatarCircleImageView(image: nil, size: .small)
    private let nicknameLabel = UILabel(text: "", font: .systemFont(ofSize: 16, weight: .bold), textColor: .tintColor, lines: 1)
    private let distanceLabel = UILabel(text: "", font: .systemFont(ofSize: 14, weight: .light), textColor: .secondaryLabel, lines: 1)
    private let timeLabel = UILabel(text: "", font: .monospacedDigitSystemFont(ofSize: 14, weight: .light), textColor: .secondaryLabel, lines: 1)
    private let tempLabel = UILabel(text: "", font: .monospacedDigitSystemFont(ofSize: 14, weight: .thin), textColor: .secondaryLabel, lines: 1)
    private let dateLabel = UILabel(text: "", font: .systemFont(ofSize: 11, weight: .light), textColor: .secondaryLabel, lines: 1)
    private let likesLabel = UILabel(text: "0 🩶", font: .monospacedDigitSystemFont(ofSize: 14, weight: .light), textColor: .secondaryLabel, lines: 1)

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
        likesLabel.textAlignment = .right
        tempLabel.textAlignment = .right
//        descriptionText.s

        let selectedView = UIView()
        selectedView.backgroundColor = Res.PRColors.prMedium
        selectedBackgroundView = selectedView

        contentView.addSubview(bgView)
        [avatarImageView, nicknameLabel, distanceLabel, descriptionText, timeLabel, tempLabel, likesLabel, dateLabel].forEach(bgView.addSubview)

        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 116),

            bgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            bgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            bgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

//            avatarImageView.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            avatarImageView.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 8),
            avatarImageView.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 8),

            nicknameLabel.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 8),
            nicknameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            nicknameLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -80),

            likesLabel.topAnchor.constraint(equalTo: nicknameLabel.topAnchor),
            likesLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -12),

            distanceLabel.leadingAnchor.constraint(equalTo: nicknameLabel.leadingAnchor),
            distanceLabel.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -6),
            timeLabel.bottomAnchor.constraint(equalTo: distanceLabel.bottomAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 72),
            tempLabel.bottomAnchor.constraint(equalTo: distanceLabel.bottomAnchor),
            tempLabel.trailingAnchor.constraint(equalTo: likesLabel.trailingAnchor, constant: -4),
            dateLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: distanceLabel.topAnchor),

            descriptionText.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 4),
            descriptionText.leadingAnchor.constraint(equalTo: nicknameLabel.leadingAnchor),
            descriptionText.trailingAnchor.constraint(equalTo: likesLabel.trailingAnchor),
            descriptionText.bottomAnchor.constraint(equalTo: distanceLabel.topAnchor, constant: -4)
        ])
    }


    // MARK: - Public method

    func fillData(with post: RunnerPost, avatar: UIImage) {
        avatarImageView.image = avatar
        nicknameLabel.text = post.userNickname
        distanceLabel.text = "\(post.distance / 1000) км"
        timeLabel.text = timeFormat(sec: post.time)
        tempLabel.text = tempFormat(sec: post.temp) + " мин/км"//"\(post.temp)"
        dateLabel.text = post.date
        descriptionText.text = post.text
    }


}
