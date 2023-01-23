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

    var rootVC: RootViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // RootVCで選択されたrepositoryを代入
        let repo = rootVC.repoArray[rootVC.selectedIndex]

        repoTitleLabel.text = repo["full_name"] as? String
        // タイトルに合わせてラベルの高さを変える
        repoTitleLabel.sizeToFit()
        repoLanguageLabel.text = "Written in \(repo["language"] as? String ?? "")"
        // 言語に合わせてラベルの高さを変える
        repoLanguageLabel.sizeToFit()
        repoStarsLabel.text = "\(repo["stargazers_count"] as? Int ?? 0) stars"
        repoWatchersLabel.text = "\(repo["watchers_count"] as? Int ?? 0) watchers"
        repoForksLabel.text = "\(repo["forks_count"] as? Int ?? 0) forks"
        repoIssuesLabel.text = "\(repo["open_issues_count"] as? Int ?? 0) open issues"
        getOwnerImage()
    }

    func getOwnerImage() {
        let repo = rootVC.repoArray[rootVC.selectedIndex]

        if let owner = repo["owner"] as? [String: Any] {
            if let imageURL = owner["avatar_url"] as? String {
                URLSession.shared.dataTask(with: URL(string: imageURL)!) { data, _, err in
                    // もしエラーが発生した場合
                    if err != nil {
                        //　後でユーザーにわかる形で表示する
                        print(err!)
                    } else {
                        // dataがnilであることを回避
                        if let ownerImage = UIImage(data: data!) {
                            DispatchQueue.main.async {
                                self.ownerImageView.image = ownerImage
                            }
                        }
                    }
                }.resume()
            }
        }
    }
}
