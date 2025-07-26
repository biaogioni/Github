//
//  RepoDetailView.swift
//  Github
//
//  Created by Beatriz Ogioni on 24/07/25.
//

import UIKit

enum RepoDetailViewType {
    case stars
    case forks
    
    var iconImage: UIImage? {
        switch self {
        case .stars:
            return UIImage(systemName: "star.fill")
        case .forks:
            return UIImage(systemName: "house")
        }
    }
}

final class RepoDetailView: UIView {
    private let iconImageView: UIImageView = {
        let iconImage = UIImageView()
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        iconImage.backgroundColor = .clear
        return iconImage
    }()
    
    private let qtdLabel: UILabel = {
        let iconValue = UILabel()
        iconValue.textColor = .orange
        iconValue.translatesAutoresizingMaskIntoConstraints = false
        iconValue.textAlignment = .left
        iconValue.font = .boldSystemFont(ofSize: 15)
        return iconValue
    }()

    init(type: RepoDetailViewType, qtd: Int) {
        super.init(frame: .zero)
        setup()
        setupQtd(qtd)
        setIcon(type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupQtd(_ value: Int) {
        qtdLabel.text = String(value)
    }
    
    private func setIcon(_ type: RepoDetailViewType) {
        iconImageView.image = type.iconImage
    }
    
}

extension RepoDetailView: ViewCodable {
    func setupViews() {
        addSubview(iconImageView)
        addSubview(qtdLabel)
    }
    
    func setupAnchors() {
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: topAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 15),
            iconImageView.widthAnchor.constraint(equalToConstant: 15),
            
            qtdLabel.topAnchor.constraint(equalTo: topAnchor),
            qtdLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 4),
            qtdLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            qtdLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            
        ])
    }
    
    func setupLayouts() {
        self.backgroundColor = .white
    }
}
