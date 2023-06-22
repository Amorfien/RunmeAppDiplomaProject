//
//  String + Extensions.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 22.06.2023.
//

import Foundation

// Локализация
extension String {

    var localized: String {
        NSLocalizedString(self, comment: self)
    }

//    let text = "Profile".localized
//
//    На всякий случай, если вам вдруг не показали на занятии, можно в меню Product выбрать Scheme и Edit Scheme, там перейти на Run режим и на вкладке Options поставить галочку Localization Debugging. Тогда все надписи без локализации на экране будут отображены в ВЕРХНЕМ РЕГИСТРЕ

}
