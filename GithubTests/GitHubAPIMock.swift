//
//  GitHubAPIMock.swift
//  Github
//
//  Created by Beatriz Ogioni on 26/07/25.
//

import Github
import Foundation

class MockGitHubAPIService: GitHubAPIServicing {
    var searchSwiftReposResult: ((Int, @escaping (Result<SearchReposResponse, Error>) -> Void) -> Void)?
    var searchSwiftPRSResult: ((String, String, @escaping (Result<[Github.PullRequest], Error>) -> Void) -> Void)?
    
    func searchSwiftRepos(page: Int, completion: @escaping (Result<SearchReposResponse, Error>) -> Void) {
        searchSwiftReposResult?(page, completion) ?? {
            completion(.failure(MockError.notImplemented))
        }()
    }
    
    func searchSwiftPRS(username: String, reponame: String, completion: @escaping (Result<[Github.PullRequest], any Error>) -> Void) {
        searchSwiftPRSResult?(username, reponame, completion) ?? {
            completion(.failure(MockError.notImplemented))
        }()
    }
    
}

enum MockError: Error, LocalizedError {
    case notImplemented
    case customError(String)
    
    var errorDescription: String? {
        switch self {
        case .notImplemented: return "Mock method not implemented."
        case .customError(let message): return message
        }
    }
}
