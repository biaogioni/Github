//
//  RepoListCoordinator.swift
//  Github
//
//  Created by Beatriz Ogioni on 17/07/25.
//

import Foundation
import UIKit

protocol RepoListCoordinatorDelegate: AnyObject {
    func navigateToPRsList(for repository: Repository)
}

final class RepoListCoordinator: Coordinator {
    var childCoordinators: [any Coordinator] = []
    var router: UINavigationController
    
    init(_ router: UINavigationController) {
        self.router = router
    }
    
    func start() {
        let viewModel = RepoListViewModel()
        let viewController = RepoListViewController(viewModel: viewModel)
        viewController.coordinator = self
        router.setViewControllers([viewController], animated: true)
    }
}

extension RepoListCoordinator: RepoListCoordinatorDelegate {
    func navigateToPRsList(for repository: Repository) {
        let coordinator = PRsListCoordinator(router, repositoryInfos: repository)
        addChild(coordinator)
        coordinator.start()
    }
    
//    func didRequestFailed(error: ErrorType) {
//        let viewController = DefaultErrorFactory.make(router, error: error)
//        router.pushViewController(viewController)
//    }
    
//    func presentAlert(_ alert: UIAlertController) {
//        router.presentAlert(alert)
//    }
}
