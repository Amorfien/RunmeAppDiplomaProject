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

        return formatter.string(from: DateComponents(second: sec)) ?? "--//--"
    } else {
        return isMale ? ".....🏃‍♂️____" : ".....🏃‍♀️____"
    }
}
