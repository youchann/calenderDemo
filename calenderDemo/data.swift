//
//  data.swift
//  calenderDemo
//
//  Created by yutaro on 2018/10/09.
//  Copyright © 2018年 yutaro. All rights reserved.
//

import Foundation
import RealmSwift

// カレンダー
class Schedule: Object {
    //    @objc dynamic var id = 0
    @objc dynamic var title = ""
    @objc dynamic var memo = ""
    @objc dynamic var startDate = Date()
    @objc dynamic var endDate = Date()

    //    // idをプライマリキーに設定
    //    override static func primaryKey() -> String? {
    //        return "id"
    //    }
}
