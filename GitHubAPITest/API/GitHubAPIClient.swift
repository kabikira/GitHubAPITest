//
//  GitHubAPIClient.swift
//  GitHubAPITest
//
//  Created by koala panda on 2024/07/20.
//

import Foundation

protocol GitHubAPIClientProtocol {
    func fetchRepositories(user: String) async throws -> [GitHubRepository]
}

class GitHubAPIClient: GitHubAPIClientProtocol {

    // ユーザ名を受け取り、そのユーザーのリポジトリ一覧を取得する。
    func fetchRepositories(user: String) async throws -> [GitHubRepository] {
        let url = URL(string: "https://api.github.com/users/\(user)/repos")!
        let request = URLRequest(url: url)

        let (data, _) = try await URLSession.shared.data(for: request)
        let repos = try JSONDecoder().decode([GitHubRepository].self, from: data)
        return repos
    }
}
