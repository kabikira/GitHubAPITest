//
//  GitHubAPITestTests.swift
//  GitHubAPITestTests
//
//  Created by koala panda on 2024/07/19.
//

import XCTest
@testable import GitHubAPITest

class MockGitHubAPIClient: GitHubAPIClientProtocol {

    var mockRepositories: [GitHubRepository]
    var requestedUser: String?

    init(mockRepositories: [GitHubRepository]) {
        self.mockRepositories = mockRepositories
    }

    func fetchRepositories(user: String) async throws -> [GitHubRepository] {
        self.requestedUser = user
        return mockRepositories
    }
}

final class GitHubAPITestTests: XCTestCase {

    var repositoryManager: GitHubRepositoryManager!
    var mockClient: MockGitHubAPIClient!

    let testRepositories: [GitHubRepository] = [
        GitHubRepository(id: 1, name: "Repo1", repositoryUrl: "https://github.com/repo1", star: 100),
        GitHubRepository(id: 2, name: "Repo2", repositoryUrl: "https://github.com/repo2", star: 150),
        GitHubRepository(id: 3, name: "Repo3", repositoryUrl: "https://github.com/repo3", star: 0),
    ]

    override func setUp() {
        super.setUp()
        // 必要な初期化を行う
        mockClient = MockGitHubAPIClient(mockRepositories: testRepositories)
        repositoryManager = GitHubRepositoryManager(client: mockClient)
    }

    override func tearDown() {
        // 必要なクリーンアップを行う
        repositoryManager = nil
        mockClient = nil
        super.tearDown()
    }

    func testLoadRepositories() async {
        do {
            try await repositoryManager.load(user: "kabikira")
            // 引数の検証
            XCTAssertEqual(mockClient.requestedUser, "kabikira")

            // 結果の検証
            // 返ってくるリポジトリの数
            XCTAssertEqual(repositoryManager.repos?.count, 3)

            // id
            XCTAssertEqual(repositoryManager.repos?[0].id, 1)
            XCTAssertEqual(repositoryManager.repos?[1].id, 2)

            // name
            XCTAssertEqual(repositoryManager.repos?[0].name, "Repo1")
            XCTAssertEqual(repositoryManager.repos?[2].name, "Repo3")

            // repositoryUrl
            XCTAssertEqual(repositoryManager.repos?[0].repositoryUrl, "https://github.com/repo1")
            XCTAssertEqual(repositoryManager.repos?[1].repositoryUrl, "https://github.com/repo2")

            // star
            XCTAssertEqual(repositoryManager.repos?[0].star, 100)
            XCTAssertEqual(repositoryManager.repos?[2].star, 0)

        } catch {
            XCTFail("Expected success but got failure with error: \(error)")
        }
    }
}

final class ViewControllerTest: XCTestCase {

    var vc: ViewController!
    var window: UIWindow!
    var mockClient: MockGitHubAPIClient!
    var repositoryManager: GitHubRepositoryManager!

    let testRepositories: [GitHubRepository] = [
        GitHubRepository(id: 1, name: "Repo1", repositoryUrl: "https://github.com/repo1", star: 100),
        GitHubRepository(id: 2, name: "Repo2", repositoryUrl: "https://github.com/repo2", star: 150),
        GitHubRepository(id: 3, name: "Repo3", repositoryUrl: "https://github.com/repo3", star: 0),
    ]

    // setUpメソッドは、各テストメソッドの前に呼び出され、テスト環境を初期化します。
    override func setUp() {
        super.setUp()
        mockClient = MockGitHubAPIClient(mockRepositories: testRepositories)
        repositoryManager = GitHubRepositoryManager(client: mockClient)
        vc = ViewController.make()
        vc.repositoryManager = repositoryManager
        window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = vc
        window.makeKeyAndVisible()
    }

    // tearDownメソッドは、各テストメソッドの後に呼び出され、テスト環境をクリーンアップします。
    override func tearDown() {
        vc = nil
        window = nil
        mockClient = nil
        repositoryManager = nil
        super.tearDown()
    }

    // サーチボタンをタップしたときのテスト
    @MainActor
    func testSearchButtonTapped() async {
        // メインスレッドでテキストフィールドにユーザー名を入力し、サーチボタンをタップ
        vc.searchTextField.text = "testUser"
        vc.searchButton.sendActions(for: .touchUpInside)


        // 非同期の検索処理が完了するのを待つ
        try? await Task.sleep(nanoseconds: 500_000_000)  // 0.5 seconds


        // ユーザー名は同じか
        XCTAssertEqual(mockClient.requestedUser, "testUser")
        // 返ってくるリポジトリの数
        XCTAssertEqual(vc.gitHubRepositories.count, testRepositories.count)

        // id
        XCTAssertEqual(vc.gitHubRepositories[0].id, 1)
        XCTAssertEqual(vc.gitHubRepositories[1].id, 2)
        XCTAssertEqual(vc.gitHubRepositories[2].id, 3)

        // name
        XCTAssertEqual(vc.gitHubRepositories[0].name, "Repo1")
        XCTAssertEqual(vc.gitHubRepositories[1].name, "Repo2")
        XCTAssertEqual(vc.gitHubRepositories[2].name, "Repo3")

        // repositoryUrl
        XCTAssertEqual(vc.gitHubRepositories[0].repositoryUrl, "https://github.com/repo1")
        XCTAssertEqual(vc.gitHubRepositories[1].repositoryUrl, "https://github.com/repo2")
        XCTAssertEqual(vc.gitHubRepositories[2].repositoryUrl, "https://github.com/repo3")

        // star
        XCTAssertEqual(vc.gitHubRepositories[0].star, 100)
        XCTAssertEqual(vc.gitHubRepositories[1].star, 150)
        XCTAssertEqual(vc.gitHubRepositories[2].star, 0)

        // インジケータが停止していることを確認
        XCTAssertFalse(vc.indicator.isAnimating)

    }
}
