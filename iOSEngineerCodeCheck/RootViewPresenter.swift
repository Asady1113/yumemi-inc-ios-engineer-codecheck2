//
//  RootViewPresenter.swift
//  iOSEngineerCodeCheck
//
//  Created by 浅田智哉 on 2023/01/29.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import UIKit

// Presenter側のプロトコル
protocol RootViewPresenterInput {
    var numberOfRepos: Int { get } // レポの数を数える
    func repo(forRow row: Int) -> [String: Any] // 選択されたレポを選ぶ
    func didSelectRowAt(_ indexPath: IndexPath) // セルが選択された時
}

// View側のプロトコル
protocol RootViewPresenterOutput {
    func didFetchRepo(_ repos: [[String: Any]]) // レポジトリが撮ってこられたときにViewに行ってほしい処理
    func performSegue(id: String) // 画面遷移
}

class RootViewPresenter: RootViewPresenterInput {
    var repoArray: [[String: Any]] = []
    var selectedIndex: Int!

    var view: RootViewPresenterOutput?
    var dataModel: RootViewModelInput

    init(with view: RootViewPresenterOutput) {
        self.view = view
        dataModel = RootViewModel()
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
        repoArray = dataModel.searchRepo(searchWord: searchBar.text!)
        view?.didFetchRepo(repoArray)
    }

    // tableViewがタップされたとき
    func didSelectRowAt(_ indexPath: IndexPath) {
        selectedIndex = indexPath.row
        view?.performSegue(id: "toDetail")
    }
}
