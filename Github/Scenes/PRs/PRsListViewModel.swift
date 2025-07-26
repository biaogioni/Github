//
//  PRsListViewModel.swift
//  Github
//
//  Created by Beatriz Ogioni on 26/07/25.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

protocol PRsListViewModelDelegate: AnyObject {
    var items: PublishSubject<[PullRequest]> { get }
    func initialLoad()
}

final class PRsListViewModel {
    let items = PublishSubject<[PullRequest]>()
    private let disposeBag = DisposeBag()
    private let repositoryInfos: Repository
    private let apiService: GitHubAPIServicing
    
    init(repositoryInfos: Repository,
         apiService: GitHubAPIServicing = GitHubAPI()) {
        self.repositoryInfos = repositoryInfos
        self.apiService = apiService
    }
}

extension PRsListViewModel: PRsListViewModelDelegate {
    func initialLoad() {
        guard let owner = repositoryInfos.owner?.login,
              let name = repositoryInfos.name else {
            // LANCAR ALERTA DE ERRO AQUI
            return
        }
        fetchRepositories(owner: owner, name: name)
    }
}
    
extension PRsListViewModel {
    private func fetchRepositories(owner: String, name: String) {
        apiService.searchSwiftPRS(username: owner, reponame: name) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let prsResponse):
                items.onNext(prsResponse)
                items.onCompleted()
            case .failure(let error):
                items.onError(error)
            }
        }
    }
}
