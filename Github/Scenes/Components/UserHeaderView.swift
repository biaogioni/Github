//
//  UserHeaderView.swift
//  Github
//
//  Created by Beatriz Ogioni on 24/07/25.
//

import UIKit

final class UserHeaderView: UIView {
    private let verticalStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.alignment = .center
        return stackview
    }()
    
    private let userImageView: UIImageView = {
        let userImage = UIImageView()
        userImage.translatesAutoresizingMaskIntoConstraints = false
        userImage.image = UIImage(systemName: "")
        userImage.layer.cornerRadius = 20
        userImage.backgroundColor = .clear
        return userImage
    }()
    
    private let usernameLabel: UILabel = {
        let username = UILabel()
        username.textColor = .black
        username.translatesAutoresizingMaskIntoConstraints = false
        username.textAlignment = .center
        username.font = .boldSystemFont(ofSize: 15)
        return username
    }()
    
    private var userImageSize: CGFloat = 60

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUserInfos(_ userInfo: User?) {
        guard let avatarURL = userInfo?.avatarURL?.absoluteString else { return }
        loadImage(from: avatarURL) { [weak self] image in
            self?.userImageView.image = image
        }
        usernameLabel.text = userInfo?.login
        setEspecificyViewDetails(stackAxis: .vertical, stackSpacing: 2, userImageSize: 60)
    }
    
    func setupUserInfos(_ userInfo: GitHubUser?) {
        guard let avatarURL = userInfo?.avatarURL?.absoluteString else { return }
        loadImage(from: avatarURL) { [weak self] image in
            self?.userImageView.image = image
        }
        usernameLabel.text = userInfo?.login
        setEspecificyViewDetails(stackAxis: .horizontal, stackSpacing: 12, userImageSize: 30)
    }
    
    private func setEspecificyViewDetails(stackAxis: NSLayoutConstraint.Axis, stackSpacing: CGFloat, userImageSize: CGFloat) {
        verticalStackView.axis = stackAxis
        verticalStackView.spacing = stackSpacing
        self.userImageSize = userImageSize
        setup()
    }
    
    func clean() {
        userImageView.image = nil
    }
}

extension UserHeaderView: ViewCodable {
    func setupViews() {
        addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(userImageView)
        verticalStackView.addArrangedSubview(usernameLabel)
    }
    
    func setupAnchors() {
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: topAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            userImageView.heightAnchor.constraint(equalToConstant: userImageSize),
            userImageView.widthAnchor.constraint(equalToConstant: userImageSize)
        ])
    }
    
    func setupLayouts() {
        self.backgroundColor = .white
    }
}
