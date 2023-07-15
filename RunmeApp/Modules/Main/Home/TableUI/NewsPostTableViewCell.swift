//
//  NewsPostTableViewCell.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 28.06.2023.
//

import UIKit

protocol NewsCellDelegate: AnyObject {
    func favoriteDidTap(post: Article)
}

final class NewsPostTableViewCell: UITableViewCell {

    static let reuseId = "NewsPostTableViewCell"

    // MARK: - Properties

    weak var cellDelegate: NewsCellDelegate? {
        didSet {
            favoriteButton.isHidden = false
        }
    }
    private var article: Article?

    private let authorLabel = UILabel(text: "", font: .systemFont(ofSize: 18, weight: .bold), textColor: .tintColor, lines: 2)
    private let sourceLabel = UILabel(text: "", font: .systemFont(ofSize: 14, weight: .light), textColor: .secondaryLabel, lines: 1)
    private let titleLabel = UILabel(text: "", font: .systemFont(ofSize: 20, weight: .medium), textColor: .tintColor, lines: 2)

    private var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemFill
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private var descriptionText = UILabel(text: "", font: .systemFont(ofSize: 14, weight: .regular), textColor: .systemGray, lines: 0)

    private lazy var linkButton: UIButton = {
        let button = UIButton()
        button.setTitle("https://", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.titleLabel?.font = .italicSystemFont(ofSize: 14)
        button.contentHorizontalAlignment = .leading
        button.addTarget(self, action: #selector(linkTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.addTarget(self, action: #selector(favoriteDoubleTap), for: .touchUpInside)
        button.isHidden = true
        button.layer.borderWidth = 0.5
//        button.backgroundColor = Res.PRColors.prLight
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupGestures()
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {

        backgroundColor = .clear//Res.MyColors.myBackground
        titleLabel.textAlignment = .center
        
        [authorLabel, sourceLabel, titleLabel, postImageView, descriptionText, linkButton, favoriteButton].forEach(contentView.addSubview)

        NSLayoutConstraint.activate([
            authorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60),

            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            favoriteButton.widthAnchor.constraint(equalToConstant: 30),
            favoriteButton.heightAnchor.constraint(equalToConstant: 30),

            sourceLabel.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            sourceLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 2),

            titleLabel.topAnchor.constraint(equalTo: sourceLabel.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            postImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            postImageView.heightAnchor.constraint(equalTo: postImageView.widthAnchor, multiplier: 0.7),

            descriptionText.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 16),
            descriptionText.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            descriptionText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            linkButton.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            linkButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            linkButton.topAnchor.constraint(equalTo: descriptionText.bottomAnchor, constant: 8),
            linkButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
        ])
    }


    private func setupGestures() {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(favoriteDoubleTap))
            tapGestureRecognizer.numberOfTapsRequired = 2
            self.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc private func favoriteDoubleTap() {
        cellDelegate?.favoriteDidTap(post: article!)
    }

    @objc private func linkTap(_ sender: UIButton) {
        guard let url = URL(string: sender.titleLabel?.text ?? "") else { return }
        UIApplication.shared.open(url)
    }

    // MARK: - Public method

    func fillData(with article: Article, indexPath: IndexPath) {
        self.article = article
        authorLabel.text = article.author
        sourceLabel.text = article.source
        titleLabel.text = article.title
        descriptionText.text = article.text
        linkButton.setTitle(article.url, for: .normal)

        //вариант загрузки из интернета или из базы данных
        if let imageData = article.image {
            postImageView.image = UIImage(data: imageData)
        } else {
            if let url = URL(string: article.urlToImage ?? "") {
                let queue = DispatchQueue.global()
                queue.async {
                    if let data = try? Data(contentsOf: url) {
                        DispatchQueue.main.async {
                            self.postImageView.image = UIImage(data: data)
                        }
                        self.article?.image = data
                    }

                }
            }
        }




    }


}
