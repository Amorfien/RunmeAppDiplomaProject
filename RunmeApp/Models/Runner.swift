//
//  User.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 24.06.2023.
//

import UIKit

struct Runner: Identifiable {

    var id: String

    let phoneNumber: String

    let name: String?
    let surname: String?
    var nickname: String?

    var avatar: UIImage?
    var avatarURL: String?

    let birthday: String?
    var birthdayShow = true
    var isAdmin = false

    var personalBests: [Int] = [0, 0, 0, 0]
    var achievements: [Int] = []

    var posts: [String] = []

    var representation: [String: Any] {
        var repres: [String: Any] = [:]
        repres["id"] = self.id
        repres["phoneNumber"] = self.phoneNumber
        repres["name"] = self.name
        repres["surname"] = self.surname
        repres["nickname"] = self.nickname
        repres["avatarURL"] = self.avatarURL
        repres["birthday"] = self.birthday
        repres["birthdayShow"] = true
        repres["isAdmin"] = false
        repres["personalBests"] = self.personalBests
        repres["achievements"] = self.achievements
        return repres
    }

}

//typealias RunTimeSec = UInt16 //0...65535 sec (18 hrs)
//
//enum PersonalBest {
//    case five(RunTimeSec)
//    case ten(RunTimeSec)
//    case half(RunTimeSec)
//    case marathon(RunTimeSec)
//}
//
//
//enum Achievement {
//    case gold
//    case silver
//    case bronze
//}
