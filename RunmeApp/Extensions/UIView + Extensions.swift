//
//  UIView + Extensions.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 03.07.2023.
//

import UIKit

func timeFormat(sec: Int?, isMale: Bool? = true) -> String {

    guard let sec else { return isMale ?? true ? "____🏃‍♂️~~~~" : "____🏃‍♀️~~~~" }
    if sec > 0, sec < 100000 {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
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
    formatter.unitsStyle = .abbreviated
    formatter.zeroFormattingBehavior = .pad
//    let seconds = Int(minutes * 60)

    return formatter.string(from: DateComponents(second: sec)) ?? "--//--"
}

//func timeStringFormat(string: String) -> Int {
//    let formatter = DateFormatter()
//    formatter.dateFormat = "HH ч mm мин ss с"
//    formatter.amSymbol = ""
//    formatter.locale = .current
//    let date = formatter.date(from: string)
//    let stringFromDate = date?.formatted(date: .omitted, time: .standard)
////    print(stringFromDate)
//    let removeAM = stringFromDate?.components(separatedBy: " ").first
//    let components = removeAM?.components(separatedBy: ":")
////    print(components)
//    let hours = (Int(components?[0] ?? "") ?? 0) * 3600
//    let minutes = (Int(components?[1] ?? "") ?? 0) * 60
//    let seconds = (Int(components?[2] ?? "") ?? 0)
//    return hours + minutes + seconds
//}


func birthdayDateToString(date: Date) -> String
{
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy"
    return formatter.string(from: date)
}
func birthdayStringToDate(string: String) -> Date?
{
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy"
    return formatter.date(from: string)
}

func timeDateToString(date: Date) -> String
{
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss"
    return formatter.string(from: date)
}
func stringToTimeDate(string: String) -> Date?
{
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss"
    return formatter.date(from: string)
}
