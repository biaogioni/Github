//
//  RepoViewCell.swift
//  Globozip
//
//  Created by Beatriz Ogioni on 04/06/25.
//

import UIKit

public protocol RepoViewCellDelegate: AnyObject {
    func clickOnShareContent(url: String?)
}

final class RepoViewCell: UITableViewCell, Reusable {
    private var repoNameLabel: UILabel = {
        let repoName = UILabel()
        repoName.translatesAutoresizingMaskIntoConstraints = false
        repoName.textColor = .black
        repoName.font = .systemFont(ofSize: 16, weight: .bold)
        return repoName
    }()
    
    private var repoDescriptionLabel: UILabel = {
        let repoDescription = UILabel()
        repoDescription.translatesAutoresizingMaskIntoConstraints = false
        repoDescription.textColor = .black
        repoDescription.font = .systemFont(ofSize: 14, weight: .regular)
        repoDescription.numberOfLines = 2
        return repoDescription
    }()
    
    private var userHeaderView: UserHeaderView = {
        let userHeader = UserHeaderView()
        userHeader.translatesAutoresizingMaskIntoConstraints = false
        return userHeader
    }()
    
    private var detailsStack: UIStackView = {
        let detailsStack = UIStackView()
        detailsStack.translatesAutoresizingMaskIntoConstraints = false
        detailsStack.spacing = 12
        return detailsStack
    }()

    public override init(style: UITableViewCell.CellStyle,
                         reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func prepareForReuse() {
        clean()
        super.prepareForReuse()
    }

    private func clean() {
        userHeaderView.clean()
        detailsStack.removeAllArrangedSubviews()
    }
}

extension RepoViewCell {
    func setInfos(infos: Repository) {
        repoNameLabel.text = infos.name
        repoDescriptionLabel.text = infos.description
        userHeaderView.setupUserInfos(infos.owner)
    
        if let stars = infos.stars {
            let starsView = RepoDetailView(type: .stars, qtd: stars)
            detailsStack.addArrangedSubview(starsView)
        }
        
        if let forks = infos.forksCount {
            let forksView = RepoDetailView(type: .forks, qtd: forks)
            detailsStack.addArrangedSubview(forksView)
        }
    }
}

extension RepoViewCell: ViewCodable {
    func setupLayouts() {
    }

    func setupViews() {
        contentView.addSubview(repoNameLabel)
        contentView.addSubview(repoDescriptionLabel)
        contentView.addSubview(detailsStack)
        contentView.addSubview(userHeaderView)
    }

    func setupAnchors() {
        NSLayoutConstraint.activate([
            repoNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            repoNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            repoDescriptionLabel.topAnchor.constraint(equalTo: repoNameLabel.bottomAnchor, constant: 6),
            repoDescriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            detailsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            detailsStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            
            userHeaderView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            userHeaderView.bottomAnchor.constraint(equalTo: bottomAnchor),
            userHeaderView.leadingAnchor.constraint(equalTo: repoDescriptionLabel.trailingAnchor, constant: 20),
            userHeaderView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            userHeaderView.heightAnchor.constraint(equalToConstant: 60),
            userHeaderView.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
}
