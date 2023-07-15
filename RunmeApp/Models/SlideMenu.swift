//
//  SlideMenu.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 05.07.2023.
//

import Foundation

enum SlideMenu: String, CaseIterable {
    case statistic = "Статистика"
    case notification = "Уведомления"
    case favorite = "Очистить"
    case settings = "Настройки"
    case exit = "Выход"

    var ico: String {
        switch self {
        case .statistic:
            return "chart.xyaxis.line"
        case .notification:
            return "bell"
        case .favorite:
            return "star.slash"
        case .settings:
            return "gearshape"
        case .exit:
            return "door.right.hand.open"
        }
    }

    var color: String {
        switch self {
        case .statistic:
            return "prLight"
        case .notification:
            return "prLight"
        case .favorite:
            return "black"
        case .settings:
            return "black"
        case .exit:
            return "black"
        }
    }

}
