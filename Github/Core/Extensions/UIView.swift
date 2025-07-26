//
//  UIView.swift
//  Github
//
//  Created by Beatriz Ogioni on 24/07/25.
//

import UIKit

extension UIView {
    func constraint(_ closure: (UIView) -> [NSLayoutConstraint]) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(closure(self))
    }
    
    public func fillSuperviewToSafeArea() {
        guard let superview = self.superview else { return }
     
        self.constraint {
           return [
                $0.topAnchor.constraint(equalTo: superview.topAnchor),
                $0.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
                $0.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                $0.bottomAnchor.constraint(equalTo: superview.bottomAnchor)
            ]
        }
    }
}
