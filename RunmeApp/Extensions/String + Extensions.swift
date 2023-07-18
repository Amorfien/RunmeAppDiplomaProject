//
//  String + Extensions.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 18.07.2023.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: self)
    }
}
