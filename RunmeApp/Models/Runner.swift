//
//  User.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 24.06.2023.
//

import Foundation

struct Runner: Identifiable {

    var id: String

//    let UID: String
    let phoneNumber: String

    let name: String?
    let surname: String?
    var nickname: String?

    let birthday: String?
    var birthdayShow = true

    var personalBests: [PersonalBest] = []
    var achievements: [Achievement] = []

    var posts: [Post] = []

    var representation: [String: Any] {
        var repres: [String: Any] = [:]
        repres["id"] = self.id
        repres["phoneNumber"] = self.phoneNumber
        repres["name"] = self.name
        repres["surname"] = self.surname
        repres["nickname"] = self.nickname
        repres["birthday"] = self.birthday
        repres["birthdayShow"] = true
        return repres
    }

}

typealias RunTimeSec = UInt16 //0...65535 sec (18 hrs)

enum PersonalBest {
    case five(RunTimeSec)
    case ten(RunTimeSec)
    case half(RunTimeSec)
    case marathon(RunTimeSec)
}


enum Achievement {
    case gold
    case silver
    case bronze
}
