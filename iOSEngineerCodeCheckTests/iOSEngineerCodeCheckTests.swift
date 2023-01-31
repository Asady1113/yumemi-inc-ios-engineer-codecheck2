//
//  iOSEngineerCodeCheckTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

@testable import iOSEngineerCodeCheck
import XCTest

class iOSEngineerCodeCheckTests: XCTestCase {
    func test_入力時何らかのリポジトリが検索されれば成功() {
        let rootModel = RootModel()
        // 実行
        let result = rootModel.searchRepo(searchWord: "Swift")
        let result_count = result.count
        // 検証
        XCTAssertNotEqual(result_count, 0)
    }

    func test_日本語入力時もnilにならなければ成功() {
        let rootModel = RootModel()
        // 実行
        let result = rootModel.searchRepo(searchWord: "ああああ")
        let result_count = result.count
        // 検証
        XCTAssertNotNil(result_count)
    }

    func test_空入力時は何も検索しない() {
        let rootModel = RootModel()
        // 実行
        let result = rootModel.searchRepo(searchWord: "")
        let result_count = result.count
        // 検証
        XCTAssertEqual(result_count, 0)
    }

    func test_画像がないときplaceholderになっていたら成功() {
        let detailModel = DetailModel()
        // 実行
        let resultImage = detailModel.getOwnerImage(repo: [:])
        XCTAssertEqual(resultImage, UIImage(named: "noimage.jpeg"))
    }

}
