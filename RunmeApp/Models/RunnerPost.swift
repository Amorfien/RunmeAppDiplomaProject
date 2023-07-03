//
//  Post.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 24.06.2023.
//

import Foundation

struct RunnerPost {

    let uid: String
    let author: String
    let date: String
    let text: String
    let distance: Int
    let time: Int
    var temp: Double {
        Double(time / distance)
    }
    var likes = 0
    
}


let testRunnerPost1 = RunnerPost(uid: "123", author: "Shusha", date: "11.11.2023", text: "ПРобежка", distance: 5, time: 1800)
let testRunnerPost2 = RunnerPost(uid: "234", author: "Кот", date: "10.10.2022", text: "Running", distance: 10, time: 3500)
let testRunnerPost3 = RunnerPost(uid: "345", author: "Медведь", date: "5.5.2023", text: "Morning", distance: 20, time: 6000)
let testRunnerPost4 = RunnerPost(uid: "456", author: "Шляпа", date: "1.1.2022", text: "Marathon, ;jnd b w;w jwj de hwehdkwbc. lkw ;we m;welkn we .welwlnwcb wlnlwecncw.cwec.c cwec", distance: 40, time: 10000)
