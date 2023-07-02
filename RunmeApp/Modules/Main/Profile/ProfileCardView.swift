//
//  ProfileCardView.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 30.06.2023.
//

import UIKit

final class ProfileCardView: UIView {

//    private let profile: Runner? = nil
    var avatar: UIImage? = nil {
        didSet {
            self.avatarImageView.image = avatar
            self.bigAvatar.image = avatar
        }
    }
//    var achiewments: [String] = []

    private var isEditable = false
    weak var delegate: UIViewController?
    private lazy var avatarImageView = AvatarCircleImageView(image: nil, size: .large, isEditable: self.isEditable, completion: changeAvatar)

    private let statusTextField = CustomTextField(type: .status)
    private let nicknameLabel = UILabel(text: "Никнэйм", font: .systemFont(ofSize: 18, weight: .semibold), textColor: .label, lines: 2)
    private let nameLabel = UILabel(text: "Name", font: .systemFont(ofSize: 16, weight: .regular), textColor: .secondaryLabel, lines: 2)
    private let surnameLabel = UILabel(text: "Фамилия", font: .systemFont(ofSize: 16, weight: .regular), textColor: .secondaryLabel, lines: 2)
    private let telegramLabel = UILabel(text: "@телеграм", font: .systemFont(ofSize: 14, weight: .light), textColor: .tertiaryLabel, lines: 1)
    private let vStack = UIStackView()
    private let birthdayLabel = UILabel(text: "--.--.----", font: .monospacedDigitSystemFont(ofSize: 14, weight: .semibold), textColor: .secondaryLabel, lines: 1)

    private let achiewmentsView = AchievementsScrollView(frame: .zero)


    private lazy var bigAvatar: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .black.withAlphaComponent(0.8)
//        view.alpha = 0.75
        view.contentMode = .scaleAspectFit
        view.image = avatarImageView.image
        view.isHidden = true
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init(delegate: UIViewController, isEditable: Bool = false) {
        super.init(frame: .zero)
        self.delegate = delegate
        self.isEditable = isEditable
        setupView()
        constraints()
        gestureToAvatar()
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
        statusTextField.delegate = delegate as? UITextFieldDelegate
        statusTextField.backgroundColor = .white.withAlphaComponent(0.1)

        addSubview(birthdayLabel)
        birthdayLabel.textAlignment = .right
        addSubview(vStack)
        vStack.axis = .vertical
        vStack.alignment = .trailing
        vStack.distribution = .fillEqually
        let mainViews = [nicknameLabel, nameLabel, surnameLabel, telegramLabel]
        mainViews.forEach { label in
            vStack.addArrangedSubview(label)
        }

        addSubview(achiewmentsView)

        addSubview(bigAvatar) //last

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
            vStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),

            statusTextField.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 24),
            statusTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            statusTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.62),
            birthdayLabel.centerYAnchor.constraint(equalTo: statusTextField.centerYAnchor),
            birthdayLabel.leadingAnchor.constraint(equalTo: statusTextField.trailingAnchor),
            birthdayLabel.trailingAnchor.constraint(equalTo: vStack.trailingAnchor),

            achiewmentsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            achiewmentsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            achiewmentsView.topAnchor.constraint(equalTo: statusTextField.bottomAnchor, constant: 12),

            bigAvatar.leadingAnchor.constraint(equalTo: leadingAnchor),
            bigAvatar.trailingAnchor.constraint(equalTo: trailingAnchor),
            bigAvatar.topAnchor.constraint(equalTo: topAnchor),
            bigAvatar.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

    }

    private func gestureToAvatar() {
        let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(avatarTap))
//        tapGesture.minimumPressDuration = 1
        avatarImageView.addGestureRecognizer(tapGesture)
    }
    @objc private func avatarTap() {
//        print("1sec")
        bigAvatar.isHidden.toggle()

//        avatarImageView.layer.cornerRadius = 0
    }

    func fillProfile(profile: Runner) {
        nicknameLabel.text = profile.nickname
        nameLabel.text = profile.name
        surnameLabel.text = profile.surname
        telegramLabel.text = profile.telegram
        statusTextField.text = profile.statusText
        birthdayLabel.text = profile.birthday
        bigAvatar.backgroundColor = (profile.isAdmin ?? false) ? .tintColor.withAlphaComponent(0.9) : .black.withAlphaComponent(0.82)
        achiewmentsView.fillAchievements(with: Set(profile.achievements ?? []))
//        achiewmentsView.
    }
    func fillAvatar(avatar: UIImage?) {
        self.avatar = avatar
//        avatarImageView.image = avatar
//        bigAvatar.image = avatar
    }

    private func changeAvatar() {
        print("ImagePicker")
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = delegate as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        delegate?.present(imagePicker, animated: true)
    }



}
