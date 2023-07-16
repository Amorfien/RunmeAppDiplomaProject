//
//  LabelWithPadding.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 28.06.2023.
//

import UIKit

class LabelWithPadding: UILabel {

    let UIEI = UIEdgeInsets(top: 5, left: 16, bottom: 5, right: 16)

    override var intrinsicContentSize: CGSize {
        numberOfLines = 0
        var s = super.intrinsicContentSize
        s.height = s.height + UIEI.top + UIEI.bottom
        s.width = s.width + UIEI.left + UIEI.right
        return s
    }

    override func drawText(in rect:CGRect) {
        let r = rect.inset(by: UIEI)
        super.drawText(in: r)
    }

    override func textRect(forBounds bounds:CGRect,
                               limitedToNumberOfLines n:Int) -> CGRect {
        let b = bounds
        let tr = b.inset(by: UIEI)
        let ctr = super.textRect(forBounds: tr, limitedToNumberOfLines: 0)
        return ctr
    }

}
