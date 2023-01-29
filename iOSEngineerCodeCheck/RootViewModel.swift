//
//  RootViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by 浅田智哉 on 2023/01/29.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import UIKit

class RootViewModel {
    let rootViewPresenter = RootViewPresenter()

    var searchTask: URLSessionTask?

    func cancelSearch() {
        // テキストが変更されたときはサーチをキャンセルする
        searchTask?.cancel()
    }

    // リポジトリを検索
    func searchRepo(searchWord: String) {
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
                            self.rootViewPresenter.repoArray = items
                        }
                    }
                }
            }
            // リスト更新のための処理
            searchTask?.resume()
        }
    }
}
