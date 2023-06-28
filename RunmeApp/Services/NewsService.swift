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

    enum NewsKeyword: String {
        case ironman
        case zoj = "зож"
        case sportrun = "спорт+бег"
    }

    let keywords = ["ironman", "зож", "спорт+бег"]

//    // поддержка кириллицы в URL
//    guard let apiURL = URL(string: urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
//        print("some Error")
//        return
//    }

    // MARK: - URL session
    func newsSession(keyword: String, completion: @escaping (Result<Data, NewsError>) -> Void) {

//    https://newsapi.org/v2/everything?q=зож&sortBy=publishedAt&apiKey=8834743500d845509e348c362ff8cfc1

        let urlComponents: URLComponents = {
//            let codedApiKey: [UInt8] = [0x35, 0x65, 0x38, 0x62, 0x36, 0x62, 0x66, 0x63]
            var url = URLComponents()
            url.scheme = "https"
            url.host = "newsapi.org"
            url.path = "/v2/everything"
            url.queryItems = [
                URLQueryItem(name: "q", value: keyword),
                URLQueryItem(name: "language", value: "ru"),
                URLQueryItem(name: "sortBy", value: "publishedAt"),
                URLQueryItem(name: "apiKey", value: "8834743500d845509e348c362ff8cfc1")
//                URLQueryItem(name: "apikey", value: String(data: Data(codedApiKey), encoding: .utf8))
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
