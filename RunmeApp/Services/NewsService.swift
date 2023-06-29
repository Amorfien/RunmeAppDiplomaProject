//
//  NewsService.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 27.06.2023.
//

import Foundation

protocol NewsProtocol {

}

final class NewsService: NewsProtocol {

    enum NewsError: String, Error {
        case badURL
        case noData
        case decodeError
        case requestError
    }

    let keywords = ["ironman", "зож", "спорт+бег"]

    // MARK: - URL session
    func newsSession(keyword: String, completion: @escaping (Result<Data, NewsError>) -> Void) {

        let urlComponents: URLComponents = {
            let codedApiKey: [UInt8] = [0x38, 0x38, 0x33, 0x34, 0x37, 0x34, 0x33, 0x35, 0x30, 0x30, 0x64, 0x38, 0x34, 0x35, 0x35, 0x30, 0x39, 0x65, 0x33, 0x34, 0x38, 0x63, 0x33, 0x36, 0x32, 0x66, 0x66, 0x38, 0x63, 0x66, 0x63, 0x31]
            var url = URLComponents()
            url.scheme = "https"
            url.host = "newsapi.org"
            url.path = "/v2/everything"
            url.queryItems = [
                URLQueryItem(name: "q", value: keyword),
                URLQueryItem(name: "language", value: "ru"),
                URLQueryItem(name: "sortBy", value: "publishedAt"),
                URLQueryItem(name: "apiKey", value: String(data: Data(codedApiKey), encoding: .utf8))
            ]
            return url
        }()


        guard let apiURL = urlComponents.url else {
            completion(.failure(.badURL))
            return
        }

        URLSession.shared.dataTask(with: apiURL) { data, response, error in
            guard let data else {
                if error != nil {
                    completion(.failure(.noData))
                }
                return
            }
            completion(.success(data))
        }.resume()
    }

    // MARK: - Public method
    func loadNews(completion: @escaping (Result<[Article], NewsError>) -> Void) {

        let group = DispatchGroup()
        var articles: [Article] = []

        for url in keywords {
            group.enter()

            newsSession(keyword: url) { result in
                switch result {
                case .success(let data):
                    do {
                        let news = try JSONDecoder().decode(News.self, from: data)
                        articles += news.articles ?? []
                        group.leave()
                    } catch {
                        print("❗️ Decode Error")
                        completion(.failure(.decodeError))
                    }
                case .failure(let error): print("‼️ Request Error ", error)
                    completion(.failure(error))
                }
            }
        }



        group.notify(queue: .global(), work: DispatchWorkItem(block: {
            sleep(1)
            completion(.success(articles))
        }))

    }



}
