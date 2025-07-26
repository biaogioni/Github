//
//  PRsListViewController.swift
//  Github
//
//  Created by Beatriz Ogioni on 26/07/25.
//

import UIKit
import RxSwift
import RxCocoa

final class PRsListViewController: UIViewController {
    private let prListView = PRsListView()
    private let viewModel: PRsListViewModelDelegate
    private let disposeBag = DisposeBag()
    
    weak var coordinator: PRsListCoordinatorDelegate?
    
    init(viewModel: PRsListViewModelDelegate) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func loadView() {
        super.loadView()
        prListView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(prListView)
        prListView.fillSuperviewToSafeArea()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        prListView.delegate = self
    }
    
    private func bindViewModel() {
        viewModel.items
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] products in
                self?.prListView.update(with: products)
            })
            .disposed(by: disposeBag)
        
         viewModel.initialLoad()
    }
}

extension PRsListViewController: PRsListViewDelegate {
    func clickOnRepo(for pr: PullRequest) {
        guard let url = pr.htmlURL else { return }
        coordinator?.didNavigateToInApp(url: url)
    }
}
