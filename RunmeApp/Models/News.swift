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
    let title, description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
//    let content: String?

    var likes = 0

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let sourceName = try container.decodeIfPresent(Source.self, forKey: .source)
        self.source = sourceName?.name
        self.author = try container.decodeIfPresent(String.self, forKey: .author)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.url = try container.decodeIfPresent(String.self, forKey: .url)
        self.urlToImage = try container.decodeIfPresent(String.self, forKey: .urlToImage)
        let date = try container.decodeIfPresent(String.self, forKey: .publishedAt)
        self.publishedAt = String((date ?? "2001-01-01T13:00:00Z").dropLast(10))
    }

    ///инит для тестовой модели
    init(source: String?, author: String?, title: String?, description: String?, url: String?, urlToImage: String?, publishedAt: String?, likes: Int = 0) {
        self.source = source
        self.author = author
        self.title = title
        self.description = description
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.likes = likes
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



let testNews1: Article = Article(source: "Novate.ru", author: "Дарина info@novate.ru", title: "ЗОЖ: О чём молчат врачи, или 5 самых частых причин постоянной усталости и слабости", description: "Когда собственным пытливым умом дойдёшь до того, какие анализы нужно сдавать буквально всем - от мала до велика - в 2023 году с средней широте, диву даёшься: «Почему же врачи об этом молчат? Что за заговор?» Причиной тому то ли некомпетентность нынешнего поко…", url: "https://novate.ru/blogs/240623/66734/", urlToImage: "https://novate.ru/preview/66734s3.jpg?53", publishedAt: "2023-06-24")

let testNews2: Article = Article(source: "Life.ru", author: "Семен Хафизов", title: "От жвачки до санитайзера: 9 \"полезных\" привычек, которые могут причинить серьёзный вред организму", description: "Вы думали, что, встав на путь ЗОЖ, больше не будете испытывать проблем со здоровьем? Во всём важна мера, и в здоровом образе жизни — в первую очередь. Некоторые из правильных привычек способны навредить сильнее пагубных. Читать далее...", url: "https://life.ru/p/1581973", urlToImage: "https://static.life.ru/publications/2023/5/26/635342642517.4824.jpg", publishedAt: "2023-05-27")
