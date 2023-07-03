//
//  UIViewController + Extensions.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 25.06.2023.
//

import UIKit

extension UIViewController {

    func showAlert(title: String, message: String, completion: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }

//    func timeFormat(sec: Int, isMale: Bool = true) -> String {
//
//        if sec > 0 {
//            let formatter = DateComponentsFormatter()
//            formatter.allowedUnits = [.hour, .minute, .second]
//            formatter.unitsStyle = .abbreviated
//
//            return formatter.string(from: DateComponents(second: sec)) ?? "--//--"
//        } else {
//            return isMale ? ".....🏃‍♂️____" : ".....🏃‍♀️____"
//        }
//    }


}
