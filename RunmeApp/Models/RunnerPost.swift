//
//  Post.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 24.06.2023.
//

import Foundation

struct RunnerPost {

//    let uid: String
    var postId: String
    let userId: String
    var userNickname: String
    let date: String
    let text: String
    let distance: Double
    let time: Double
    var temp: Double {
        time / (distance / 1000)
    }
    var likes: [String] = []

    var representation: [String: Any] {
        var repres: [String: Any] = [:]
//        repres["uid"] = self.uid
        repres["postId"] = self.postId
        repres["userId"] = self.userId
        repres["userNickname"] = self.userNickname
        repres["date"] = self.date
        repres["text"] = self.text
        repres["distance"] = self.distance
        repres["time"] = self.time
        repres["temp"] = self.temp
        repres["likes"] = self.likes

        return repres
    }
    
}

extension RunnerPost: Comparable {
    static func < (lhs: RunnerPost, rhs: RunnerPost) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        guard let leftDate = formatter.date(from: lhs.date), let rightDate = formatter.date(from: rhs.date) else { return false }
        return leftDate > rightDate
    }


}
