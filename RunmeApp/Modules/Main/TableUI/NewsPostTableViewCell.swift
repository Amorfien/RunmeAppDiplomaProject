//
//  NewsPostTableViewCell.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 28.06.2023.
//

import UIKit

final class NewsPostTableViewCell: UITableViewCell {

    static let reuseId = "NewsPostTableViewCell"

    // MARK: - Properties
    private var authorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
//        label.textColor = Palette.title
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemFill
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private var descriptionText: UILabel = {
        let desc = UILabel()
        desc.numberOfLines = 0
        desc.textColor = .systemGray
        desc.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        desc.translatesAutoresizingMaskIntoConstraints = false
        return desc
    }()

    private var likesLabel: UILabel = {
        let likes = UILabel()
//        likes.textColor = Palette.tabbar
        likes.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        likes.translatesAutoresizingMaskIntoConstraints = false
        return likes
    }()

    private var viewsLabel: UILabel = {
        let views = UILabel()
//        views.textColor = Palette.tabbar
        views.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        views.textAlignment = .right
        views.translatesAutoresizingMaskIntoConstraints = false
        return views
    }()

    private let saveToFavoriteImage: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "heart"))
        image.tintColor = .darkGray
        image.isHidden = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private var post: Article?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {

        backgroundColor = Res.MyColors.homeBackground
        
        [authorLabel, postImageView, descriptionText, likesLabel, viewsLabel, saveToFavoriteImage].forEach(contentView.addSubview)

        NSLayoutConstraint.activate([
            authorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            authorLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            authorLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),

//            postImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            postImageView.heightAnchor.constraint(equalTo: postImageView.widthAnchor),
            postImageView.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 12),

            descriptionText.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 16),
            descriptionText.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            descriptionText.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),

            likesLabel.topAnchor.constraint(equalTo: descriptionText.bottomAnchor, constant: 16),
            likesLabel.leftAnchor.constraint(equalTo: descriptionText.leftAnchor),
            likesLabel.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width / 2) - 16),
            likesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),

            viewsLabel.topAnchor.constraint(equalTo: likesLabel.topAnchor),
            viewsLabel.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width / 2) - 16),
            viewsLabel.rightAnchor.constraint(equalTo: descriptionText.rightAnchor),

            saveToFavoriteImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            saveToFavoriteImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 50),
            saveToFavoriteImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
            saveToFavoriteImage.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25)
        ])
    }


    private func setupGestures() {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(favoriteDoubleTap))
            tapGestureRecognizer.numberOfTapsRequired = 2
            self.addGestureRecognizer(tapGestureRecognizer)
    }

    private func animation() {
        self.saveToFavoriteImage.isHidden = false

        UIView.animate(withDuration: 1.0, delay: 0) {
            self.saveToFavoriteImage.transform = CGAffineTransform(scaleX: 3.9, y: 3.9)
        } completion: { _ in
            self.saveToFavoriteImage.transform = .identity
            self.saveToFavoriteImage.isHidden = true
        }
    }

    @objc private func favoriteDoubleTap() {

//        let newDBService = CDserviceVer3()
//
//        // сравниммаю хранимые посты по названию фотографии
//        newDBService.fetchPosts(predicate: NSPredicate(format: "id == %ld", post!.id)) {
//            newDBService.addToDb(post: post!)
//            self.animation()
//        }
    }

    // MARK: - Public method

    func fillData(with article: Article, indexPath: IndexPath) {
        authorLabel.text = article.author
        //        postImageView.image = UIImage(named: "mosaic")
        if let url = URL(string: article.urlToImage ?? "") {
            let queue = DispatchQueue.global()
            queue.async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.postImageView.image = UIImage(data: data)
                    }
                }

            }
        }
        descriptionText.text = article.description
        likesLabel.text = "Likes: \(article.likes) ♡"
        viewsLabel.text = "Section-\(indexPath.section), Row-\(indexPath.row)"
    }


}
