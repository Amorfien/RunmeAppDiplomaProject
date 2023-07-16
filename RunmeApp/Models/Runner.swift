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

    var nickname: String
    let name: String?
    let surname: String?
    var statusText: String?
    let isMale: Bool

    let email: String?
    let telegram: String?

    var avatar: UIImage?

    let birthday: String?
    var birthdayShow: Bool = true
    var isAdmin: Bool = false

    var personalBests: [Int] = [0, 0, 0, 0]
    var achievements: [String]?// = []

    var postsId: [String]? = []
    var likesId: [String]? = []
    
    var representation: [String: Any] {
        var repres: [String: Any] = [:]
        repres["id"] = self.id
        repres["phoneNumber"] = self.phoneNumber
        repres["nickname"] = self.nickname
        repres["name"] = self.name
        repres["surname"] = self.surname
        repres["statusText"] = self.statusText
        repres["isMale"] = self.isMale
        repres["email"] = self.email
        repres["telegram"] = self.telegram
        repres["birthday"] = self.birthday
        repres["birthdayShow"] = self.birthdayShow
        repres["isAdmin"] = self.isAdmin
        repres["personalBests"] = self.personalBests
        repres["achievements"] = self.achievements

        repres["postsId"] = self.postsId
        repres["likesId"] = self.likesId
        return repres
    }

}

struct RunnersBests: Identifiable {
    var id: String
    var nickname: String
    var isMale: Bool
    var personalBests: [Int] = [0, 0, 0, 0]
}
