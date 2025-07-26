//
//  PRViewCell.swift
//  Github
//
//  Created by Beatriz Ogioni on 26/07/25.
//

import UIKit

public protocol PRViewCellDelegate: AnyObject {
    func clickOnShareContent(url: String?)
}

final class PRViewCell: UITableViewCell, Reusable {
    private var prStack: UIStackView = {
        let prStack = UIStackView()
        prStack.translatesAutoresizingMaskIntoConstraints = false
        prStack.spacing = 6
        prStack.axis = .vertical
        prStack.alignment = .leading
        return prStack
    }()
    
    private var repoNameLabel: UILabel = {
        let repoName = UILabel()
        repoName.translatesAutoresizingMaskIntoConstraints = false
        repoName.textColor = .black
        repoName.font = .systemFont(ofSize: 16, weight: .bold)
        repoName.numberOfLines = 2
        return repoName
    }()
    
    private var repoDescriptionLabel: UILabel = {
        let repoDescription = UILabel()
        repoDescription.translatesAutoresizingMaskIntoConstraints = false
        repoDescription.textColor = .black
        repoDescription.font = .systemFont(ofSize: 14, weight: .regular)
        repoDescription.numberOfLines = 0
        return repoDescription
    }()
    
    private var userHeaderView: UserHeaderView = {
        let userHeader = UserHeaderView()
        userHeader.translatesAutoresizingMaskIntoConstraints = false
        return userHeader
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
        super.prepareForReuse()
    }
}

extension PRViewCell {
    func setInfos(infos: PullRequest) {
        repoNameLabel.text = infos.title
        repoDescriptionLabel.text = infos.body
        userHeaderView.setupUserInfos(infos.user)
    }
}

extension PRViewCell: ViewCodable {
    func setupLayouts() {
    }

    func setupViews() {
        contentView.addSubview(prStack)
        prStack.addArrangedSubview(repoNameLabel)
        prStack.addArrangedSubview(repoDescriptionLabel)
        prStack.addArrangedSubview(userHeaderView)
    }

    func setupAnchors() {
        NSLayoutConstraint.activate([
            prStack.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            prStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            prStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            prStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
}
