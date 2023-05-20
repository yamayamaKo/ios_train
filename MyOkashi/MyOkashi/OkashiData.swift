//
//  OkashiData.swift
//  MyOkashi
//
//  Created by 山田紘暉 on 2023/05/21.
//

import Foundation

// おかしデータ検索用クラス
class OkashiData: ObservableObject {
    func searchOkashi(keyword: String) {
        print("searchOkashiメソッドで受け取った値:\(keyword)")
    }
}
