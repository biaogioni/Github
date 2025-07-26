//
//  SearchResponse.swift
//  Github
//
//  Created by Beatriz Ogioni on 17/07/25.
//

import Foundation

public struct SearchReposResponse: Codable, Equatable {
    let totalCount: Int?
    let incompleteResults: Bool?
    let items: [Repository]?

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

public struct Repository: Codable, Equatable {
    let id: Int?
    let name: String?
    let fullName: String?
    let owner: User?
    let description: String?
    let stars: Int?
    let forksCount: Int?

    enum CodingKeys: String, CodingKey {
        case id, name
        case fullName = "full_name"
        case owner, description
        case stars = "stargazers_count"
        case forksCount = "forks_count"
    }
}

public struct User: Codable, Equatable {
    let login: String
    let id: Int
    let avatarURL: URL?

    enum CodingKeys: String, CodingKey {
        case login, id
        case avatarURL = "avatar_url"
    }
}
