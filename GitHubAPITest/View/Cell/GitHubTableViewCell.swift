//
//  GitHubTableViewCell.swift
//  GitHubAPITest
//
//  Created by koala panda on 2024/07/21.
//

import UIKit

final class GitHubTableViewCell: UITableViewCell {
    static var className: String { String(describing: GitHubTableViewCell.self) }

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel.text = nil
        self.starLabel.text = nil
    }

    func configure(gitHubRepository: GitHubRepository) {
        self.nameLabel.text = gitHubRepository.name
        self.starLabel.text = String(gitHubRepository.star)
    }
}
