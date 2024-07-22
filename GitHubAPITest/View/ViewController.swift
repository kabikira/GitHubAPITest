//
//  ViewController.swift
//  GitHubAPITest
//
//  Created by koala panda on 2024/07/19.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchButton: UIButton! {
        didSet {
            searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        }
    }
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib.init(nibName: GitHubTableViewCell.className, bundle: nil), forCellReuseIdentifier: GitHubTableViewCell.className)
            tableView.dataSource = self
        }
    }

    let repositoryManager = GitHubRepositoryManager()
    var gitHubRepositories: [GitHubRepository] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @objc func searchButtonTapped() {
        guard let username = searchTextField.text, !username.isEmpty else {
            print("Username is empty")
            return
        }
        performSearch(for: username)
    }

    func performSearch(for username: String) {
        indicator.startAnimating()
        Task {
            do {
                try await repositoryManager.load(user: username)
                if let repos = repositoryManager.repos {
                    updateUI(with: repos)
                }
            } catch {
                print("Failed to load repositories: \(error)")
            }
            indicator.stopAnimating()
        }
    }

    func updateUI(with repositories: [GitHubRepository]) {
        gitHubRepositories = repositories
        tableView.reloadData()
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

