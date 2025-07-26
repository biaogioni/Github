//
//  GitHubAPI.swift
//  Globozip
//
//  Created by Beatriz Ogioni on 04/06/25.
//

import Foundation

public protocol GitHubAPIServicing {
    func searchSwiftRepos(page: Int, completion: @escaping (Result<SearchReposResponse, Error>) -> Void)
    func searchSwiftPRS(username: String, reponame: String, completion: @escaping (Result<[PullRequest], Error>) -> Void)
}

enum GitHubApiEndpoints {
    case repos(page: Int)
    case prs(username: String, reponame: String)
    
    private var baseEndpoint: String {
        return "https://api.github.com/"
    }
    
    private var path: String {
        switch self {
        case let .repos(page):
            return "search/repositories?q=language:swift&sort=stars&page=\(page)"
        case let .prs(username, reponame):
            return "repos/\(username)/\(reponame)/pulls"
        }
    }
    
    var endpoint: String {
        return "\(baseEndpoint)\(path)"
    }
}

struct GitHubAPI: GitHubAPIServicing {
    private let urlSession: URLSession

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    func searchSwiftRepos(page: Int = 1, completion: @escaping (Result<SearchReposResponse, Error>) -> Void) {
        let urlString = GitHubApiEndpoints.repos(page: page)
        makeGetRequest(requestUrl: urlString.endpoint, completion: completion)
    }

    func searchSwiftPRS(username: String, reponame: String, completion: @escaping (Result<[PullRequest], Error>) -> Void) {
        let urlString = GitHubApiEndpoints.prs(username: username, reponame: reponame)
        makeGetRequest(requestUrl: urlString.endpoint, completion: completion)
    }

    private func makeGetRequest<T: Decodable>(requestUrl: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: requestUrl) else {
            DispatchQueue.main.async {
                completion(.failure(URLError(.badURL)))
            }
            return
        }

        let task = urlSession.dataTask(with: url) { data, response, error in
            if let error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data else {
                DispatchQueue.main.async {
                    completion(.failure(URLError(.badServerResponse)))
                }
                return
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            do {
                let result = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } catch {
                print("Decoding Error: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }

        task.resume()
    }
}
