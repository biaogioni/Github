//
//  InAppViewController.swift
//  Github
//
//  Created by Beatriz Ogioni on 26/07/25.
//

import UIKit
import SafariServices

final class InAppViewController: SFSafariViewController, SFSafariViewControllerDelegate {
    init(url: URL) {
        super.init(url: url, configuration: SFSafariViewController.Configuration())
        delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
