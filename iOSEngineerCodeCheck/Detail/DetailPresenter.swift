//
//  DetailPresenter.swift
//  iOSEngineerCodeCheck
//
//  Created by 浅田智哉 on 2023/01/30.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import UIKit

// Presenter → View
protocol DetailPresenterOutput {
    // オーナーのイメージ取得後の処理
    func didFetchImage(ownerImage: UIImage)
    // もしエラーが生じたら
    func didFetchError(error: Error)
}

// view → Presenter
protocol DetailPresenterInput {
    // オーナーのイメージ取得指示
    func getOwnerImage(repo: [String: Any])
}

class DetailPresenter: DetailPresenterInput {
    var view: DetailPresenterOutput?
    var dataModel: DetailModelInput

    init(with view: DetailPresenterOutput) {
        self.view = view
        dataModel = DetailModel()
    }

    // ownerの画像取得をモデルに依頼、帰ってきたものをViewへ
    func getOwnerImage(repo: [String: Any]) {
        let result = dataModel.getOwnerImage(repo: repo)
        // エラーの有無を判定
        if result.error != nil {
            view?.didFetchError(error: result.error!)
        } else {
            view?.didFetchImage(ownerImage: result.ownerImage)
        }
    }
}
