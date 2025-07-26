//
//  ViewCodable.swift
//  Github
//
//  Created by Beatriz Ogioni on 17/07/25.
//

import UIKit

protocol ViewCodable {
    func setup()
    func setupViews()
    func setupAnchors()
    func setupLayouts()
}

extension ViewCodable {
    func setup() {
        setupViews()
        setupAnchors()
        setupLayouts()
    }
}
