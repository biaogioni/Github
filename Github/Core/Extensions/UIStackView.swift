//
//  UIStackView.swift
//  Github
//
//  Created by Beatriz Ogioni on 24/07/25.
//

import UIKit

extension UIStackView {
    func removeAllArrangedSubviews() {
        arrangedSubviews.forEach { view in
            removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}
