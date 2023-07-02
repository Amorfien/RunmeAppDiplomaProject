//
//  ProfileCardView.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 30.06.2023.
//

import UIKit

final class ProfileCardView: UIView {

//    private let profile: Runner? = nil
//    private let avatar: UIImage? = nil

    private var isEditable = false
    private lazy var avatarImageView = AvatarCircleImageView(image: nil, size: .large, isEditable: self.isEditable, completion: changeAvatar)

    private let statusTextField = CustomTextField(type: .status)
    private let nicknameLabel = UILabel(text: "Никнэйм", font: .systemFont(ofSize: 18, weight: .semibold), textColor: .label, lines: 2)
    private let nameLabel = UILabel(text: "Name", font: .systemFont(ofSize: 16, weight: .regular), textColor: .secondaryLabel, lines: 2)
    private let surnameLabel = UILabel(text: "Фамилия", font: .systemFont(ofSize: 16, weight: .regular), textColor: .secondaryLabel, lines: 2)
    private let telegramLabel = UILabel(text: "@телеграм", font: .systemFont(ofSize: 14, weight: .light), textColor: .tertiaryLabel, lines: 1)
    private let vStack = UIStackView()

    init(isEditable: Bool = false) {
        super.init(frame: .zero)
        self.isEditable = isEditable
        setupView()
        constraints()

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private func setupView() {
        backgroundColor = .tertiarySystemBackground.withAlphaComponent(0.5)

        layer.cornerRadius = 10
        layer.borderWidth = 1

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 10
        
        addSubview(avatarImageView)
        addSubview(statusTextField)
        statusTextField.isEnabled = self.isEditable
        addSubview(vStack)
        vStack.axis = .vertical
        vStack.alignment = .trailing
        vStack.distribution = .fillEqually
        let mainViews = [nicknameLabel, nameLabel, surnameLabel, telegramLabel]
        mainViews.forEach { label in
            vStack.addArrangedSubview(label)
        }

    }

    private func constraints() {
        translatesAutoresizingMaskIntoConstraints = false
        vStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.9),
            self.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 1.2),

            avatarImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),

            vStack.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            vStack.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            vStack.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
            vStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            statusTextField.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 24),
            statusTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            statusTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])

    }

    func fillProfile(profile: Runner) {
        nicknameLabel.text = profile.nickname
        nameLabel.text = profile.name
        surnameLabel.text = profile.surname
        telegramLabel.text = profile.telegram
        statusTextField.text = profile.statusText
    }
    func fillAvatar(avatar: UIImage?) {
        avatarImageView.image = avatar
    }

    private func changeAvatar() {
        print("ImagePicker")
    }



}
