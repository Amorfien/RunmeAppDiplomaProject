//
//  ViewModelProtocol.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 22.06.2023.
//

import Foundation

protocol ViewModelProtocol: AnyObject {
    func phoneFormatter(number: String?) -> String
}

extension ViewModelProtocol {
    func phoneFormatter(number: String?) -> String {

        guard let number else { return "" }
        let s1 = number.dropLast(10)
        let s2 = number.dropLast(7).dropFirst(2)
        let s3 = number.dropLast(4).dropFirst(5)
        let s4 = number.dropLast(2).dropFirst(8)
        let s5 = number.dropFirst(10)
        let formattingPhone = String(format: "%@ (%@) %@-%@-%@", [s1, s2, s3, s4, s5] as [CVarArg])
        return formattingPhone
    }
}
