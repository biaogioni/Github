//
//  PullRequest.swift
//  Github
//
//  Created by Beatriz Ogioni on 24/07/25.
//

import Foundation

public struct PullRequest: Codable, Equatable {
    let id: Int
    let number: Int?
    let state: String?
    let title: String
    let body: String?
    let user: GitHubUser?
    let htmlURL: URL?
    let mergeable: Bool?
    let draft: Bool?

    enum CodingKeys: String, CodingKey {
        case id, number, state, title, body, user
        case htmlURL = "html_url"
        case mergeable, draft
    }
}

public struct GitHubUser: Codable, Equatable {
    let login: String
    let id: Int
    let avatarURL: URL?
    let htmlURL: URL

    enum CodingKeys: String, CodingKey {
        case login, id
        case avatarURL = "avatar_url"
        case htmlURL = "html_url"
    }
}
