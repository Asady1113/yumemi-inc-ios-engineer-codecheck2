//
//  RootViewPresenter.swift
//  iOSEngineerCodeCheck
//
//  Created by 浅田智哉 on 2023/01/29.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import UIKit

protocol RootViewPresenterInput {
    var numberOfRepos: Int { get } // レポの数を数える
    func repo(forRow row: Int) -> [String: Any] // 選択されたレポを選ぶ
    func didSelectRowAt(_ indexPath: IndexPath) // よーわからん
}

protocol RootViewPresenterOutput {
    func didFetchRepo(_ repos: [[String: Any]]) // よーわからん
}

class RootViewPresenter: RootViewPresenterInput {
    var repoArray: [[String: Any]] = []

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
        dataModel.cancelSearch()
    }

    // searchバーを押されたとき
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        repoArray = dataModel.searchRepo(searchWord: searchBar.text!)
        view?.didFetchRepo(repoArray)
    }

    // tableViewがタップされたとき
    func didSelectRowAt(_: IndexPath) {}
}
