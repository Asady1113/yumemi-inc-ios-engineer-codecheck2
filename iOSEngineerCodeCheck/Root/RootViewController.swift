//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class RootViewController: UITableViewController {
    var presenter: RootPresenter!

    @IBOutlet var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = RootPresenter(with: self)
        searchBar.delegate = self
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return presenter.numberOfRepos
    }

    override func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let repo = presenter.repo(forRow: indexPath.row)
        cell.textLabel?.text = repo["full_name"] as? String ?? ""
        cell.detailTextLabel?.text = repo["language"] as? String ?? ""
        cell.tag = indexPath.row
        return cell
    }

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRowAt(indexPath)
    }
}

extension RootViewController: RootPresenterOutput {
    // 情報がとってこられたら
    func didFetchRepo(_: [[String: Any]]) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func performSegue(id: String) {
        performSegue(withIdentifier: id, sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        // 画面遷移の際の値わたし
        if segue.identifier == "toDetail" {
            let detailVC = segue.destination as! DetailViewController
            detailVC.repo = presenter.repoArray[presenter.selectedIndex]
        }
    }
}

extension RootViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // 初期のテキストを消す処理(Viewの処理のみで完結するので、Presenterに渡さない）
        searchBar.text = ""
        return true
    }

    func searchBar(_: UISearchBar, textDidChange _: String) {
        presenter.searchBarTextDidChange()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.searchBarSearchButtonClicked(searchBar)
    }
}
