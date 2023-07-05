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
            return ""
        case .bookmarks:
            return ""
        case .favorite:
            return ""
        case .settings:
            return "gearshape"
        case .exit:
            return "door.right.hand.open"
        }
    }
}
