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
    var gitHubRepository: [GitHubRepository] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        Task {
            do {
                try await repositoryManager.load(user: "kabikira")
                if let repos = repositoryManager.repos {
                    self.gitHubRepository = repos
                    self.tableView.reloadData()
                }
            } catch {
                print("Failed to load repositories: \(error)")
            }
        }
    }
    
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gitHubRepository.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GitHubTableViewCell.className) as? GitHubTableViewCell else {
            fatalError()
        }
        let gitHubRepository = gitHubRepository[indexPath.row]
        cell.configure(gitHubRepository: gitHubRepository)
        return cell
    }
}

extension ViewController: UITableViewDelegate {

}

