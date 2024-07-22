//
//  ViewController.swift
//  GitHubAPITest
//
//  Created by koala panda on 2024/07/19.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib.init(nibName: GitHubTableViewCell.className, bundle: nil), forCellReuseIdentifier: GitHubTableViewCell.className)
            tableView.delegate = self
            tableView.dataSource = self
        }
    }

    let repositoryManager = GitHubRepositoryManager()
    var gitHubRepositories: [GitHubRepository] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // searchButtonにアクションを追加
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
    }

    @objc func searchButtonTapped() {
        guard let username = searchTextField.text, !username.isEmpty else {
            print("Username is empty")
            return
        }

        // 検索中にインジケータを表示
        indicator.startAnimating()

        Task {
            do {
                try await repositoryManager.load(user: username)
                if let repos = self.repositoryManager.repos {
                    self.gitHubRepositories = repos
                    self.tableView.reloadData()
                }
            } catch {
                print("Failed to load repositories: \(error)")
            }
            // 検索完了後にインジケータを非表示
            self.indicator.stopAnimating()
        }
    }

}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gitHubRepositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GitHubTableViewCell.className) as? GitHubTableViewCell else {
            fatalError()
        }
        let gitHubRepositories = gitHubRepositories[indexPath.row]
        cell.configure(gitHubRepository: gitHubRepositories)
        return cell
    }
}

extension ViewController: UITableViewDelegate {

}

