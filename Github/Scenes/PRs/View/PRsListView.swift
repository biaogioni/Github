//
//  PRsListView.swift
//  Github
//
//  Created by Beatriz Ogioni on 26/07/25.
//

import UIKit
import RxSwift
import RxRelay

protocol PRsListViewDelegate: AnyObject {
    func clickOnRepo(for pr: PullRequest)
}

final class PRsListView: UIView {
    private lazy var prTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alwaysBounceVertical = true
        return view
    }()
    
    private let prsRelay = BehaviorRelay<[PullRequest]>(value: [])
    private let bag = DisposeBag()
    
    weak var delegate: PRsListViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        bindTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindTableView() {
        prTableView.rx.setDelegate(self).disposed(by: bag)
        prTableView.register(PRViewCell.self, forCellReuseIdentifier: PRViewCell.identifier)
        setLoadingInfos()
        setClickOnCell()
    }
    
    private func setLoadingInfos() {
        prsRelay
            .bind(to: prTableView.rx.items(cellIdentifier: PRViewCell.identifier,
                                             cellType: PRViewCell.self)) { (row, item, cell) in
                cell.setInfos(infos: item)
            }.disposed(by: bag)
    }
    
    private func setClickOnCell() {
        prTableView.rx.modelSelected(PullRequest.self).subscribe(onNext: { [weak self] item in
            self?.delegate?.clickOnRepo(for: item)
        }).disposed(by: bag)
    }
}

extension PRsListView {
    func update(with prsInfos: [PullRequest]) {
        prsRelay.accept(prsInfos)
    }
}

extension PRsListView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
}

extension PRsListView: ViewCodable {
    func setupViews() {
        addSubview(prTableView)
    }
    
    func setupAnchors() {
        NSLayoutConstraint.activate([
            prTableView.topAnchor.constraint(equalTo: topAnchor),
            prTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            prTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            prTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setupLayouts() {
        prTableView.backgroundColor = .white
    }
}
