//
//  ViewController.swift
//  Github
//
//  Created by Beatriz Ogioni on 17/07/25.
//

import UIKit
import RxSwift
import RxCocoa

class RepoListViewController: UIViewController {
    private let repoListView = RepoListView()
    private let viewModel: RepoListViewModelDelegate
    private let disposeBag = DisposeBag()
    
    weak var coordinator: RepoListCoordinatorDelegate?
    
    init(viewModel: RepoListViewModelDelegate) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func loadView() {
        super.loadView()
        repoListView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(repoListView)
        repoListView.fillSuperviewToSafeArea()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        repoListView.delegate = self
    }
    
    private func bindViewModel() {
        viewModel.items
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] products in
                self?.repoListView.update(with: products)
            })
            .disposed(by: disposeBag)
        
         viewModel.initialLoad()
    }
}

extension RepoListViewController: RepoListViewDelegate {
    func loadMoreOptions() {
        viewModel.loadNextPage()
    }
    
    func clickOnRepo(for repository: Repository) {
        coordinator?.navigateToPRsList(for: repository)
    }
}
