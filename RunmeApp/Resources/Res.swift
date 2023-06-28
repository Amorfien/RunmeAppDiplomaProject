//
//  Res.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 22.06.2023.
//

import UIKit

struct Res {

    enum Offset: CGFloat {
        ///8
        case small = 8
        ///16
        case medium = 16
        ///40
        case large = 40
    }



    enum MyColors {
        static let myBackground = UIColor(named: "myBackground")
        static let homeBackground = UIColor(named: "homeBackground")
        static let profileBackground = UIColor(named: "profileBackground")
        static let favoriteBackground = UIColor(named: "favoriteBackground")

    }

}
