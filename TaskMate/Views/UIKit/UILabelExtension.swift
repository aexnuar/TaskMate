//
//  UILabelExtension.swift
//  TaskMate
//
//  Created by aex on 26.10.2025.
//

import UIKit

extension UILabel {
    convenience init(isBold: Bool, fontSize: CGFloat, fontColor: UIColor? = nil) {
        self.init()
        textAlignment = .left
        font = isBold ? .boldSystemFont(ofSize: fontSize) : .systemFont(ofSize: fontSize)
        textColor = fontColor ?? .label
    }
}
