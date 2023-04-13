//
//  BarthDayUtil.swift
//  BodyManager
//
//  Created by 佐藤汰一 on 2022/02/20.
//

import Foundation

// 生年月日関連のユーティリティクラス
class BarthDayUtil {
    
    // 現在の年齢を計算する処理
    static func caluculateAge() -> Int{
        guard let barthDay = UserDefaults.standard.value(forKey: "barthDate") as? Date else { return -1 }
        let barthComponent = Calendar.current.dateComponents([.year, .month, .day], from: barthDay)
        let calender = Calendar.current
        let now = calender.dateComponents([.year, .month, .day], from: Date())
        let ageComponent = calender.dateComponents([.year], from: barthComponent, to: now)
        return ageComponent.year!
    }
}
