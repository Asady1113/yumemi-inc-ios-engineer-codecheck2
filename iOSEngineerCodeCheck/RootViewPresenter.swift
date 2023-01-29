//
//  RootViewPresenter.swift
//  iOSEngineerCodeCheck
//
//  Created by 浅田智哉 on 2023/01/29.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import UIKit

class RootViewPresenter {
    let rootViecController = RootViewController()
    let rootViewModel = RootViewModel()

    var repoArray: [[String: Any]] = []

    func searchBarTextDidChange() {
        rootViewModel.cancelSearch()
    }

    // searchバーを押されたとき
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        rootViewModel.searchRepo(searchWord: searchBar.text!)
        rootViecController.didFetchRepo()
    }

    // tableViewがタップされたとき
    func didSelectRowAt(_: IndexPath) {}
}
