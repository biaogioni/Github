//
//  RepoListView.swift
//  Github
//
//  Created by Beatriz Ogioni on 17/07/25.
//

import UIKit
import RxSwift
import RxRelay

public protocol RepoListViewDelegate: AnyObject {
    func clickOnRepo(for repository: Repository)
    func loadMoreOptions()
}

final class RepoListView: UIView {
    private lazy var feedTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alwaysBounceVertical = true
        return view
    }()
    
    private let repositorysRelay = BehaviorRelay<[Repository]>(value: [])
    private let bag = DisposeBag()
    
    weak var delegate: RepoListViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        bindTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindTableView() {
        feedTableView.rx.setDelegate(self).disposed(by: bag)
        feedTableView.register(RepoViewCell.self, forCellReuseIdentifier: RepoViewCell.identifier)
        setLoadingInfos()
        setLoadingMoreInfos()
        setClickOnCell()
    }
    
    private func setLoadingInfos() {
        repositorysRelay
            .bind(to: feedTableView.rx.items(cellIdentifier: RepoViewCell.identifier,
                                             cellType: RepoViewCell.self)) { (row, item, cell) in
                cell.setInfos(infos: item)
            }.disposed(by: bag)
    }
    
    private func setLoadingMoreInfos() {
        feedTableView.rx.didScroll
          .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
          .subscribe(onNext: { [weak self] _ in
              guard let self else { return }
              let offsetY = self.feedTableView.contentOffset.y
              let contentHeight = self.feedTableView.contentSize.height
              let frameHeight = self.feedTableView.frame.size.height

              if offsetY > contentHeight - frameHeight * 1.5 {
                  self.delegate?.loadMoreOptions()
              }
          })
          .disposed(by: bag)
    }
    
    private func setClickOnCell() {
        feedTableView.rx.modelSelected(Repository.self).subscribe(onNext: { [weak self] item in
            self?.delegate?.clickOnRepo(for: item)
        }).disposed(by: bag)
    }
}

extension RepoListView {
    func update(with repositorys: [Repository]) {
        repositorysRelay.accept(repositorys)
    }
}

extension RepoListView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105.0
    }
}

extension RepoListView: ViewCodable {
    func setupViews() {
        addSubview(feedTableView)
    }
    
    func setupAnchors() {
        NSLayoutConstraint.activate([
            feedTableView.topAnchor.constraint(equalTo: topAnchor),
            feedTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            feedTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            feedTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setupLayouts() {
        feedTableView.backgroundColor = .white
    }
}
