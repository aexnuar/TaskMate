//
//  UILabelExtension.swift
//  TaskMate
//
//  Created by aex on 26.10.2025.
//

import UIKit

extension UILabel {
    convenience init(isBold: Bool, fontSize: CGFloat, fontColor: UIColor? = nil, numberOfLines: Int = 2) {
        self.init()
        textAlignment = .left
        self.numberOfLines = numberOfLines
        font = isBold ? .boldSystemFont(ofSize: fontSize) : .systemFont(ofSize: fontSize)
        textColor = fontColor ?? .customWhiteForFont
    }
}
