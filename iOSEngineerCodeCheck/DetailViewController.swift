//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var ownerImageView: UIImageView!
    
    @IBOutlet weak var repoTitleLabel: UILabel!
    
    @IBOutlet weak var repoLanguageLabel: UILabel!
    
    @IBOutlet weak var repoStarsLabel: UILabel!
    @IBOutlet weak var repoWatchersLabel: UILabel!
    @IBOutlet weak var repoForksLabel: UILabel!
    @IBOutlet weak var repoIssuesLabel: UILabel!
    
    var rootVC: RootViewController!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let repo = rootVC.repoArray[rootVC.selectedIndex]
        
        repoLanguageLabel.text = "Written in \(repo["language"] as? String ?? "")"
        repoStarsLabel.text = "\(repo["stargazers_count"] as? Int ?? 0) stars"
        repoWatchersLabel.text = "\(repo["wachers_count"] as? Int ?? 0) watchers"
        repoForksLabel.text = "\(repo["forks_count"] as? Int ?? 0) forks"
        repoIssuesLabel.text = "\(repo["open_issues_count"] as? Int ?? 0) open issues"
        getOwnerImage()
        
    }
    
    func getOwnerImage(){
        
        let repo = rootVC.repoArray[rootVC.selectedIndex]
        
        repoTitleLabel.text = repo["full_name"] as? String
        
        if let owner = repo["owner"] as? [String: Any] {
            if let imageURL = owner["avatar_url"] as? String {
                URLSession.shared.dataTask(with: URL(string: imageURL)!) { (data, res, err) in
                    let ownerImage = UIImage(data: data!)!
                    DispatchQueue.main.async {
                        self.ownerImageView.image = ownerImage
                    }
                }.resume()
            }
        }
        
    }
    
}
