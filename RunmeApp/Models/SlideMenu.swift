//
//  SlideMenu.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 05.07.2023.
//

import Foundation

enum SlideMenu: String, CaseIterable {
    case files = "Файлы"
    case bookmarks = "Закладки"
    case favorite = "Избранное"
    case settings = "Настройки"
    case exit = "Выход"

    var ico: String {
        switch self {
        case .files:
            return "doc.text"
        case .bookmarks:
            return "bookmark"
        case .favorite:
            return "star"
        case .settings:
            return "gearshape"
        case .exit:
            return "door.right.hand.open"
        }
    }

    var color: String {
        switch self {
        case .files:
            return "prLight"
        case .bookmarks:
            return "prLight"
        case .favorite:
            return "prLight"
        case .settings:
            return "black"
        case .exit:
            return "black"
        }
    }

}
