//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class RootViewController: UITableViewController, UISearchBarDelegate {
    var rootViewPresenter: RootViewPresenter!

    @IBOutlet var searchBar: UISearchBar!

    var repoArray: [[String: Any]] = []
    var searchTask: URLSessionTask?
    var selectedIndex: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // 初期のテキストを消す処理
        searchBar.text = ""
        return true
    }

    func searchBar(_: UISearchBar, textDidChange _: String) {
        rootViewPresenter.searchBarTextDidChange()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        rootViewPresenter.searchBarSearchButtonClicked(searchBar)
    }

    // 情報がとってこられたら
    func didFetchRepo() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        // 画面遷移の際の値わたし
        if segue.identifier == "toDetail" {
            let detailVC = segue.destination as! DetailViewController
            detailVC.rootVC = self
        }
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return rootViewPresenter.repoArray.count
    }

    override func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let repo = rootViewPresenter.repoArray[indexPath.row]
        cell.textLabel?.text = repo["full_name"] as? String ?? ""
        cell.detailTextLabel?.text = repo["language"] as? String ?? ""
        cell.tag = indexPath.row
        return cell
    }

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        // タップされたセル番号を取得
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "toDetail", sender: self)
    }
}
