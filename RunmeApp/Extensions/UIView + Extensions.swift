//
//  UIView + Extensions.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 03.07.2023.
//

import UIKit

extension UIView {

    func timeFormat(sec: Int?, seconds: Bool = true, isMale: Bool? = true) -> String {
        guard let sec else { return isMale ?? true ? "____🏃‍♂️~~~~" : "____🏃‍♀️~~~~" }
        if sec > 0, sec < 100000 {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = seconds ? [.hour, .minute, .second] : [.hour, .minute]
            formatter.unitsStyle = .abbreviated
            formatter.zeroFormattingBehavior = .pad

            return formatter.string(from: DateComponents(second: sec)) ?? "--//--"
        } else if sec == 100001 {
            return "admin__🚶‍♂️_"
        } else {
            return isMale ?? true ? "____🏃‍♂️~~~~" : "____🏃‍♀️~~~~"
        }
    }

    func tempFormat(sec: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad

        return formatter.string(from: DateComponents(second: sec)) ?? "--//--"
    }

    func birthdayDateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
    func birthdayStringToDate(string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.date(from: string)
    }
    func timeDateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: date)
    }
    func stringToTimeDate(string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.date(from: string)
    }

}
