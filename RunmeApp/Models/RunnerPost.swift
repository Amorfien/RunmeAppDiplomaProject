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


//let testRunnerPost1 = RunnerPost(author: "Shusha", date: "11.11.2023", text: "ПРобежка", distance: 5000, time: 1800)
//let testRunnerPost2 = RunnerPost(author: "Кот", date: "10.10.2022", text: "Running", distance: 10000, time: 3500)
//let testRunnerPost3 = RunnerPost(author: "Медведь", date: "5.5.2023", text: "Morning", distance: 20000, time: 6000)
//let testRunnerPost4 = RunnerPost(author: "Шляпа", date: "1.1.2022", text: "Marathon, ;jnd b w;w jwj de hwehdkwbc. lkw ;we m;welkn we .welwlnwcb wlnlwecncw.cwec.c cwec", distance: 40000, time: 10000)
