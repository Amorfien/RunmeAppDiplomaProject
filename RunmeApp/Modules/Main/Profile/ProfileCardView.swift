//
//  ProfileCardView.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 30.06.2023.
//

import UIKit

final class ProfileCardView: UIView {

    var avatar: UIImage? = nil {
        didSet {
            self.avatarImageView.image = avatar
            self.bigAvatar.image = avatar
        }
    }

    private var isEditable = false
    weak var delegate: UIViewController?
    private lazy var avatarImageView = AvatarCircleImageView(image: nil, size: .large, isEditable: self.isEditable, completion: changeAvatar)

    private let statusTextField = RegistrationTextField(type: .status)
    private let nicknameLabel = UILabel(text: "Никнэйм", font: .systemFont(ofSize: 18, weight: .semibold), textColor: .label, lines: 2)
    private let nameLabel = UILabel(text: "Name", font: .systemFont(ofSize: 16, weight: .regular), textColor: .secondaryLabel, lines: 2)
    private let surnameLabel = UILabel(text: "Фамилия", font: .systemFont(ofSize: 16, weight: .regular), textColor: .secondaryLabel, lines: 2)
    private let telegramLabel = UILabel(text: "@телеграм", font: .systemFont(ofSize: 14, weight: .light), textColor: .tertiaryLabel, lines: 1)
    private let vStack = UIStackView()
    private let birthdayLabel = UILabel(text: "--.--.----", font: .monospacedDigitSystemFont(ofSize: 14, weight: .semibold), textColor: .secondaryLabel, lines: 1)

    private let achiewmentsView = AchievementsScrollView(frame: .zero)

    private let distanceStack = UIStackView()
    private let fiveLabel = DistanceLabel(type: .five)
    private let tenLabel = DistanceLabel(type: .ten)
    private let twentyLabel = DistanceLabel(type: .twenty)
    private let fortyLabel = DistanceLabel(type: .forty)


    private lazy var bigAvatar: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = Res.PRColors.prDark!.withAlphaComponent(0.9)
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
        backgroundColor = .white.withAlphaComponent(0.8)

        layer.cornerRadius = 12
        layer.borderWidth = 1

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 10
        
        addSubview(avatarImageView)
        addSubview(statusTextField)
        statusTextField.isEnabled = self.isEditable
        statusTextField.returnKeyType = .done
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

        addSubview(distanceStack)
        distanceStack.axis = .vertical
//        distanceStack.alignment = .trailing
        distanceStack.distribution = .equalSpacing
        let distanceViews = [fiveLabel, tenLabel, twentyLabel, fortyLabel]
        distanceViews.forEach { label in
            distanceStack.addArrangedSubview(label)
        }

        addSubview(bigAvatar) //last

    }

    private func constraints() {
        translatesAutoresizingMaskIntoConstraints = false
        vStack.translatesAutoresizingMaskIntoConstraints = false
        distanceStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
//            self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.9),
//            self.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 1.3),

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

            distanceStack.topAnchor.constraint(equalTo: achiewmentsView.bottomAnchor, constant: 16),
            distanceStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            distanceStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 48),
            distanceStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -48),
            distanceStack.heightAnchor.constraint(equalToConstant: 180),

            bigAvatar.leadingAnchor.constraint(equalTo: leadingAnchor),
            bigAvatar.trailingAnchor.constraint(equalTo: trailingAnchor),
            bigAvatar.topAnchor.constraint(equalTo: topAnchor),
            bigAvatar.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

    }

    private func gestureToAvatar() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(avatarTap))
        avatarImageView.addGestureRecognizer(longPressGesture)
    }
    @objc private func avatarTap(_ sender: UILongPressGestureRecognizer) {
        if sender.state != .ended {
            bigAvatar.isHidden = false
        } else {
            UIView.animate(withDuration: 0.4) {
                self.bigAvatar.alpha = 0
            } completion: { _ in
                self.bigAvatar.isHidden = true
                self.bigAvatar.alpha = 1
            }
        }
    }

    func fillProfile(profile: Runner) {
        nicknameLabel.text = profile.nickname
        nameLabel.text = profile.name
        surnameLabel.text = profile.surname
        telegramLabel.text = profile.telegram
        statusTextField.text = profile.statusText
        birthdayLabel.text = profile.birthday
        bigAvatar.backgroundColor = profile.isAdmin ? .tintColor.withAlphaComponent(0.9) : Res.PRColors.prDark!.withAlphaComponent(0.9)
        achiewmentsView.fillAchievements(with: Set(profile.achievements))
        fiveLabel.text = timeFormat(sec: profile.personalBests[0], isMale: profile.isMale)
        tenLabel.text = timeFormat(sec: profile.personalBests[1], isMale: profile.isMale)
        twentyLabel.text = timeFormat(sec: profile.personalBests[2], isMale: profile.isMale)
        fortyLabel.text = timeFormat(sec: profile.personalBests[3], isMale: profile.isMale)
        if profile.isAdmin {
            distanceStack.heightAnchor.constraint(equalToConstant: 0).isActive = true
        }
    }
    func fillAvatar(avatar: UIImage?) {
        self.avatar = avatar

    }

    private func changeAvatar() {
        print("ImagePicker")
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = delegate as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        delegate?.present(imagePicker, animated: true)
    }



}
