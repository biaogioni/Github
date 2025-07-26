//
//  PRsListCoordinatorDelegate.swift
//  Github
//
//  Created by Beatriz Ogioni on 26/07/25.
//

import Foundation
import UIKit

protocol PRsListCoordinatorDelegate: AnyObject {
    func didNavigateToInApp(url: URL)
}

final class PRsListCoordinator: Coordinator {
    var childCoordinators: [any Coordinator] = []
    
    var router: UINavigationController
    private var repositoryInfos: Repository
    
    init(_ router: UINavigationController, repositoryInfos: Repository) {
        self.router = router
        self.repositoryInfos = repositoryInfos
    }
    
    func start() {
        let viewModel = PRsListViewModel(repositoryInfos: repositoryInfos)
        let viewController = PRsListViewController(viewModel: viewModel)
        viewController.coordinator = self
        router.pushViewController(viewController, animated: true)
    }
}

extension PRsListCoordinator: PRsListCoordinatorDelegate {
    func didNavigateToInApp(url: URL) {
        let viewController = InAppViewController(url: url)
        addChild(self)
        viewController.modalPresentationStyle = .pageSheet
        viewController.modalTransitionStyle = .coverVertical
        router.present(viewController, animated: true, completion: nil)
    }
}
