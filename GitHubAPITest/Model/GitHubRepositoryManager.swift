//
//  GitHubRepositoryManager.swift
//  GitHubAPITest
//
//  Created by koala panda on 2024/07/20.
//

import Foundation

class GitHubRepositoryManager {

    // 型をGitHubAPIClientProtocolに変更
    private let client: GitHubAPIClientProtocol
    private(set) var repos: [GitHubRepository]?

    // イニシャライザー経由で渡す､clientが指定されてないときのデフォルト引数を設定
    init(client: GitHubAPIClientProtocol = GitHubAPIClient()) {
        self.client = client
    }

    // 指定されたユーザ名のリポジトリ一覧を非同期で取得
    func load(user: String) async throws {
        let repositories = try await client.fetchRepositories(user: user)
        self.repos = repositories
    }
}
