//
//  DetailModel.swift
//  iOSEngineerCodeCheck
//
//  Created by 浅田智哉 on 2023/01/30.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import KRProgressHUD
import UIKit

// Modelへのプロトコル
protocol DetailModelInput {
    func getOwnerImage(repo: [String: Any]) -> UIImage
}

class DetailModel: DetailModelInput {
    func getOwnerImage(repo: [String: Any]) -> UIImage {
        // 非同期処理への対応
        let semaphore = DispatchSemaphore(value: 0)

        var ownerImage = UIImage(named: "noimage.jpeg")!

        if let owner = repo["owner"] as? [String: Any] {
            if let imageURL = owner["avatar_url"] as? String {
                URLSession.shared.dataTask(with: URL(string: imageURL)!) { data, _, err in
                    // もしエラーが発生した場合
                    if err != nil {
                        //本来ならViewControllerに記述するのがベスト？
                        KRProgressHUD.showError(withMessage: err?.localizedDescription)
                    } else {
                        // dataがnilであることを回避
                        if let image = UIImage(data: data!) {
                            ownerImage = image
                            semaphore.signal()
                        }
                    }
                }.resume()
            }
        }
        semaphore.wait()
        return ownerImage
    }
}
