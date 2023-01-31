//
//  RootViewPresenter.swift
//  iOSEngineerCodeCheck
//
//  Created by 浅田智哉 on 2023/01/29.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import UIKit

// view → Presenter
protocol RootPresenterInput {
    var numberOfRepos: Int { get } // レポの数を数える
    func repo(forRow row: Int) -> [String: Any] // 選択されたレポを選ぶ
    func searchBarTextDidChange()
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    func didSelectRowAt(_ indexPath: IndexPath) // セルが選択された時
}

// Presenter → View
protocol RootPresenterOutput {
    func didFetchRepo(_ repos: [[String: Any]]) // レポジトリが撮ってこられたときにViewに行ってほしい処理
    func didFetchError(error: Error) // エラーを受け取った時
    func performSegue(id: String) // 画面遷移
}

class RootPresenter: RootPresenterInput {
    var repoArray: [[String: Any]] = []
    var selectedIndex: Int!

    var view: RootPresenterOutput?
    var dataModel: RootModelInput

    init(with view: RootPresenterOutput) {
        self.view = view
        dataModel = RootModel()
    }

    var numberOfRepos: Int {
        return repoArray.count
    }

    func repo(forRow row: Int) -> [String: Any] {
        if row >= repoArray.count {
            return [:]
        }
        return repoArray[row]
    }

    func searchBarTextDidChange() {
        // モデルで検索をキャンセル
        dataModel.cancelSearch()
    }

    // searchバーを押されたとき
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // モデルでリポを検索、結果をViewに送る
        let result = dataModel.searchRepo(searchWord: searchBar.text!)
        if result.error != nil {
            view?.didFetchError(error: result.error!)
        } else {
            repoArray = result.itemArr
            view?.didFetchRepo(repoArray)
        }
    }

    // tableViewがタップされたとき
    func didSelectRowAt(_ indexPath: IndexPath) {
        selectedIndex = indexPath.row
        view?.performSegue(id: "toDetail")
    }
}
