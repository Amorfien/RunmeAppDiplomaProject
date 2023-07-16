//
//  News.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 27.06.2023.
//

import UIKit

// MARK: - News
struct News: Codable {
    let status: String?
    let totalResults: Int?
    let articles: [Article]?
}

// MARK: - Article
struct Article: Codable {
    let source: String?
    let author: String?
    let title, text: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?

    var image: Data?

    enum CodingKeys: String, CodingKey {
        case source, author, title
        case text = "description"
        case url, urlToImage, publishedAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let sourceName = try container.decodeIfPresent(Source.self, forKey: .source)
        self.source = sourceName?.name
        self.author = try container.decodeIfPresent(String.self, forKey: .author)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.text = try container.decodeIfPresent(String.self, forKey: .text)
        self.url = try container.decodeIfPresent(String.self, forKey: .url)
        self.urlToImage = try container.decodeIfPresent(String.self, forKey: .urlToImage)
        let date = try container.decodeIfPresent(String.self, forKey: .publishedAt)
        self.publishedAt = String((date ?? "2001-01-01T13:00:00Z").dropLast(10))
    }

    init(newsCoreDataModel: NewsCoreDataModel) {
        self.author = newsCoreDataModel.author
        self.source = newsCoreDataModel.source
        self.title = newsCoreDataModel.title
        self.text = newsCoreDataModel.text
        self.url = newsCoreDataModel.url
        self.urlToImage = newsCoreDataModel.urlToImage
        self.publishedAt = newsCoreDataModel.publishedAt
        self.image = newsCoreDataModel.image
    }
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String?
}

// MARK: - Extensions
extension Article: Comparable {
    static func < (lhs: Article, rhs: Article) -> Bool {
        lhs.publishedAt! < rhs.publishedAt!
    }

}
