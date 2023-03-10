//
//  RootViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by 浅田智哉 on 2023/01/29.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import UIKit

protocol RootModelInput {
    func cancelSearch()
    func searchRepo(searchWord: String) -> (itemArr: [[String: Any]], error: Error?)
}

class RootModel: RootModelInput {
    var searchTask: URLSessionTask?

    func cancelSearch() {
        // テキストが変更されたときはサーチをキャンセルする
        searchTask?.cancel()
    }

    // リポジトリを検索
    func searchRepo(searchWord: String) -> (itemArr: [[String: Any]], error: Error?) {
        // 非同期処理への対応
        let semaphore = DispatchSemaphore(value: 0)

        var itemArr: [[String: Any]] = []
        var error: Error?
        // 空文字かどうか判定する
        if searchWord.isEmpty == false {
            //　検索ワードに日本語が含まれる可能性があるため
            let searchEncodeString = searchWord.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
            let searchUrl = "https://api.github.com/search/repositories?q=\(searchEncodeString!)"
            searchTask = URLSession.shared.dataTask(with: URL(string: searchUrl)!) { data, _, err in
                // もしエラーが発生した場合
                if err != nil {
                    error = err
                } else {
                    if let object = try! JSONSerialization.jsonObject(with: data!) as? [String: Any] {
                        if let items = object["items"] as? [[String: Any]] {
                            itemArr = items
                            semaphore.signal()
                        }
                    }
                }
            }
            // リスト更新のための処理
            searchTask?.resume()
        }
        semaphore.wait()
        return (itemArr, error)
    }
}
