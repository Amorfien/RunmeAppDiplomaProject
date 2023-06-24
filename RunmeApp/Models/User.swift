//
//  User.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 24.06.2023.
//

import Foundation

struct User {

    let UID: String
    let phoneNumber: String

    let name: String?
    let surname: String?
    var nickname: String?

    let birthDate: Date?
    var birthDateShow = true

    var personalBests: [PersonalBest] = []
    var achievements: [Achievement] = []

    var posts: [Post] = []

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
