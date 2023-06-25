//
//  Running.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 24.06.2023.
//

import Foundation

///Пробежки-тренировки
struct Running {

    let distance: Distance
    let time: Int//RunTimeSec

}

enum Distance: Int {
    case oneKm = 1000
    case twoKm = 2000
    case fiveKm = 5000
    case tenKm = 10000
    case fifteen = 15000
    case twenty = 20000
    case half = 21098
    case marathon = 42195

}
