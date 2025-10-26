//
//  UIStackViewExtension.swift
//  TaskMate
//
//  Created by aex on 26.10.2025.
//

import UIKit

extension UIStackView {
    convenience init(
        views: [UIView],
        alignment: Alignment = .fill,
        axis: NSLayoutConstraint.Axis,
        spacing: CGFloat
    ) {
        self.init(arrangedSubviews: views)
        self.alignment = alignment
        self.axis = axis
        self.spacing = spacing
    }
}
