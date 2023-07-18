//
//  ProfileCardView.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 30.06.2023.
//

import UIKit

final class ProfileCardView: UIView {

    // MARK: - Properties

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
    private let nicknameLabel = UILabel(text: "", font: .systemFont(ofSize: 18, weight: .semibold), textColor: .label, lines: 2)
    private let nameLabel = UILabel(text: "", font: .systemFont(ofSize: 16, weight: .regular), textColor: .secondaryLabel, lines: 2)
    private let surnameLabel = UILabel(text: "", font: .systemFont(ofSize: 16, weight: .regular), textColor: .secondaryLabel, lines: 2)
    private lazy var telegramLinkButton: UIButton = {
        let button = UIButton()
        button.setTitle("@телеграм", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.titleLabel?.font = .italicSystemFont(ofSize: 16)
        button.contentHorizontalAlignment = .trailing
        button.addTarget(self, action: #selector(linkTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let vStack = UIStackView()
    private let birthdayLabel = UILabel(text: "--.--.----", font: .monospacedDigitSystemFont(ofSize: 14, weight: .semibold), textColor: .secondaryLabel, lines: 1)

    private lazy var achiewmentsView = AchievementsScrollView(delegate: delegate!)
    lazy var achButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "trophy.circle"), for: .normal)
        button.addTarget(self, action: #selector(achBtnTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let noAchLabel = UILabel(text: "тут будут мои награды".localized, font: .systemFont(ofSize: 14, weight: .light), textColor: .secondaryLabel, lines: 1)
    private lazy var achiewmentsCollection = AchievementsCollectionView(delegate: delegate!)
    private lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeLastView))

    private let distanceStack = UIStackView()
    private let fiveLabel = DistanceLabel(type: .five)
    private let tenLabel = DistanceLabel(type: .ten)
    private let twentyLabel = DistanceLabel(type: .twenty)
    private let fortyLabel = DistanceLabel(type: .forty)

    private lazy var bigAvatar: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = Res.PRColors.prDark//!.withAlphaComponent(0.9)
        view.contentMode = .scaleAspectFit
        view.image = avatarImageView.image
        view.isHidden = true
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init

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
    deinit {
        print(#function, " ProfileCardView 📺")
    }

    // MARK: - Setup view

    private func setupView() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.tintColor.cgColor
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
        let mainViews = [nicknameLabel, nameLabel, surnameLabel, telegramLinkButton]
        mainViews.forEach { label in
            vStack.addArrangedSubview(label)
        }
        addSubview(achiewmentsView)
        achiewmentsView.addSubview(achButton)
        achiewmentsView.addSubview(noAchLabel)
        noAchLabel.isHidden = true
        addSubview(distanceStack)
        distanceStack.axis = .vertical
        distanceStack.distribution = .equalSpacing
        let distanceViews = [fiveLabel, tenLabel, twentyLabel, fortyLabel]
        distanceViews.forEach { label in
            distanceStack.addArrangedSubview(label)
        }
        addSubview(bigAvatar)
    }

    private func constraints() {
        translatesAutoresizingMaskIntoConstraints = false
        vStack.translatesAutoresizingMaskIntoConstraints = false
        distanceStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),

            vStack.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            vStack.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            vStack.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
            vStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28),

            statusTextField.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 24),
            statusTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            statusTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.62),
            birthdayLabel.centerYAnchor.constraint(equalTo: statusTextField.centerYAnchor),
            birthdayLabel.leadingAnchor.constraint(equalTo: statusTextField.trailingAnchor),
            birthdayLabel.trailingAnchor.constraint(equalTo: vStack.trailingAnchor, constant: 4),

            achiewmentsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            achiewmentsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            achiewmentsView.topAnchor.constraint(equalTo: statusTextField.bottomAnchor, constant: 12),
            achButton.centerYAnchor.constraint(equalTo: achiewmentsView.centerYAnchor),
            achButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            achButton.widthAnchor.constraint(equalToConstant: 40),
            achButton.heightAnchor.constraint(equalToConstant: 40),
            noAchLabel.centerYAnchor.constraint(equalTo: achiewmentsView.centerYAnchor),
            noAchLabel.centerXAnchor.constraint(equalTo: achiewmentsView.centerXAnchor),

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

    // MARK: - Actions

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
    @objc private func achBtnTap() {
        self.addSubview(achiewmentsCollection)
        achiewmentsCollection.frame = self.bounds
        achiewmentsCollection.addGestureRecognizer(tapGesture)
    }
    @objc func removeLastView() {
        achiewmentsCollection.removeGestureRecognizer(tapGesture)
        achiewmentsCollection.removeFromSuperview()
    }
    @objc private func linkTap(_ sender: UIButton) {
        var link = sender.titleLabel?.text ?? ""
        if link.first == "@" {
            link.removeFirst()
        }
        guard let url = URL(string: "https://t.me/" + link) else { return }
        UIApplication.shared.open(url)
    }

    private func changeAvatar() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = delegate as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        delegate?.present(imagePicker, animated: true)
    }

    // MARK: - Public method

    func fillProfile(profile: Runner) {
        nicknameLabel.text = profile.nickname
        nameLabel.text = profile.name
        surnameLabel.text = profile.surname
        telegramLinkButton.setTitle(profile.telegram, for: .normal)
        statusTextField.text = profile.statusText
        birthdayLabel.text = profile.birthday
        birthdayLabel.isHidden = !profile.birthdayShow
        bigAvatar.backgroundColor = profile.isAdmin ? .tintColor.withAlphaComponent(0.9) : Res.PRColors.prDark!.withAlphaComponent(0.9)
        achiewmentsView.fillAchievements(with: Set(profile.achievements ?? []))
        fiveLabel.text = timeFormat(sec: profile.personalBests[0], isMale: profile.isMale)
        tenLabel.text = timeFormat(sec: profile.personalBests[1], isMale: profile.isMale)
        twentyLabel.text = timeFormat(sec: profile.personalBests[2], isMale: profile.isMale)
        fortyLabel.text = timeFormat(sec: profile.personalBests[3], isMale: profile.isMale)
        if profile.achievements?.isEmpty ?? true {
            noAchLabel.isHidden = false
            achButton.isEnabled = false
        }
        if profile.isAdmin {
            distanceStack.heightAnchor.constraint(equalToConstant: 0).isActive = true
        }
    }
    
    func fillAvatar(avatar: UIImage?) {
        self.avatar = avatar
    }

}
