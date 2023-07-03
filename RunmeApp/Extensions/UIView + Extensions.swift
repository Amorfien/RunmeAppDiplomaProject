//
//  UIView + Extensions.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 03.07.2023.
//

import UIKit

func timeFormat(sec: Int, isMale: Bool = true) -> String {

    if sec > 0, sec < 100000 {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .pad

        return formatter.string(from: DateComponents(second: sec)) ?? "--//--"
    } else if sec == 100001 {
        return "admin__🚶‍♂️_"
    } else {
        return isMale ? "____🏃‍♂️~~~~" : "____🏃‍♀️~~~~"
    }
}
