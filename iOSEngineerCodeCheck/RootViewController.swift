//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class RootViewController: UITableViewController, UISearchBarDelegate {
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
        // テキストが変更されたときはサーチをキャンセルする
        searchTask?.cancel()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchWord = searchBar.text!

        // 空文字かどうか判定する
        if searchWord.isEmpty == false {
            //　検索ワードに日本語が含まれる可能性があるため
            let searchEncodeString = searchWord.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
            let searchUrl = "https://api.github.com/search/repositories?q=\(searchEncodeString!)"
            searchTask = URLSession.shared.dataTask(with: URL(string: searchUrl)!) { data, _, err in
                // もしエラーが発生した場合
                if err != nil {
                    //　後でユーザーにわかる形で表示する
                    print(err!)
                } else {
                    if let object = try! JSONSerialization.jsonObject(with: data!) as? [String: Any] {
                        if let items = object["items"] as? [[String: Any]] {
                            self.repoArray = items
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
            // リスト更新のための処理
            searchTask?.resume()
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
        return repoArray.count
    }

    override func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let repo = repoArray[indexPath.row]
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
