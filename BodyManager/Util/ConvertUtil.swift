//
//  convertUtil.swift
//  BodyManager
//
//  Created by 佐藤汰一 on 2021/11/13.
//

import Foundation

class ConvertUtil {
    
    let alert = AlertUtil()
    
    // 引数の文字列が数字に変換可能か確認する
    func checkStringIsNumber(checkString:String) -> String {
        if checkString.isNumber() {
            return checkString
        }else{
            return ""
        }
    }
    
}

extension String{
    func isNumber() -> Bool {
        let pattern = "^[\\d]+$"
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return false}
        let matches = regex.matches(in: self, range: NSRange(location: 0, length: self.count))
        return matches.count > 0
    }
}
