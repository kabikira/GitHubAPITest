//
//  ViewController.swift
//  GitHubAPITest
//
//  Created by koala panda on 2024/07/19.
//

import UIKit

class ViewController: UIViewController {

    let repositoryManager = GitHubRepositoryManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        Task {
            do {
                try await repositoryManager.load(user: "kabikira")
                if let repos = repositoryManager.repos {
                    print("Repositories: \(repos)")
                }
            } catch {
                print("Failed to load repositories: \(error)")
            }
        }
    }
    
}

