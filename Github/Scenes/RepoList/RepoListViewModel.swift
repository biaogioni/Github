//
//  RepoListViewModel.swift
//  Github
//
//  Created by Beatriz Ogioni on 17/07/25.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

protocol RepoListViewModelDelegate: AnyObject {
    var items: BehaviorRelay<[Repository]> { get }
    func initialLoad()
    func loadNextPage()
}

final class RepoListViewModel {
    let items = BehaviorRelay<[Repository]>(value: [])
    private let disposeBag = DisposeBag()
    private var currentPage = 1
    private var isFetching = false
    private var isLoading = false
    
    private let apiService: GitHubAPIServicing
    
    init(apiService: GitHubAPIServicing = GitHubAPI()) {
        self.apiService = apiService
    }
}

extension RepoListViewModel: RepoListViewModelDelegate {
    func initialLoad() {
        currentPage = 1
        items.accept([])
        loadNextPage()
    }
    
    func loadNextPage() {
        guard !isLoading else { return }
        isLoading = true
        fetchRepositories(page: currentPage)
            .subscribe(onNext: { [weak self] newRepos in
                guard let self = self else { return }
                let currentRepos = self.items.value
                let updatedRepos = currentRepos + newRepos
                self.items.accept(updatedRepos)
                self.currentPage += 1
            }, onError: { [weak self] error in
                print("Erro ao carregar repositórios: \(error)")
                self?.isLoading = false
            }, onCompleted: { [weak self] in
                self?.isLoading = false
            })
            .disposed(by: disposeBag)
    }
}
    
extension RepoListViewModel {
    private func fetchRepositories(page: Int) -> Observable<[Repository]> {
        return Observable.create { [weak self ]observer in
            self?.apiService.searchSwiftRepos(page: page) { result in
               switch result {
               case .success(let searchResponse):
                   if let repItems = searchResponse.items {
                       observer.onNext(repItems)
                       observer.onCompleted()
                   } else {
                       observer.onNext([])
                       observer.onCompleted()
                   }
               case .failure(let error):
                   observer.onError(error)
               }
            }
            return Disposables.create()
        }
    }
}
