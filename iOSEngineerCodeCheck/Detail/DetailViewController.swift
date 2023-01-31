//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var ownerImageView: UIImageView!

    @IBOutlet var repoTitleLabel: UILabel!

    @IBOutlet var repoLanguageLabel: UILabel!

    @IBOutlet var repoStarsLabel: UILabel!
    @IBOutlet var repoWatchersLabel: UILabel!
    @IBOutlet var repoForksLabel: UILabel!
    @IBOutlet var repoIssuesLabel: UILabel!

    var presenter: DetailPresenter!
    var repo: [String: Any] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = DetailPresenter(with: self)
        presenter.getOwnerImage(repo: repo)

        repoTitleLabel.text = repo["full_name"] as? String
        repoLanguageLabel.text = "Written in \(repo["language"] as? String ?? "")"
        // 内容に合わせてラベルのサイズを変える
        changeLabelSize(label: repoTitleLabel)
        changeLabelSize(label: repoLanguageLabel)

        repoStarsLabel.text = "\(repo["stargazers_count"] as? Int ?? 0) stars"
        repoWatchersLabel.text = "\(repo["watchers_count"] as? Int ?? 0) watchers"
        repoForksLabel.text = "\(repo["forks_count"] as? Int ?? 0) forks"
        repoIssuesLabel.text = "\(repo["open_issues_count"] as? Int ?? 0) open issues"
    }

    func changeLabelSize(label: UILabel) {
        label.sizeToFit()
    }
}

extension DetailViewController: DetailPresenterOutput {
    func didFetchImage(ownerImage: UIImage) {
        DispatchQueue.main.async {
            self.ownerImageView.image = ownerImage
        }
    }
}
