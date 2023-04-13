//
//  UiViewExtention.swift
//  BodyManager
//
//  Created by 佐藤汰一 on 2022/02/06.
//

import Foundation
import UIKit

extension UIView{
    
    // 全てのsubViewを削除する
    public func removeAllSubViews(){
        self.subviews.forEach { subView in
            subView.removeFromSuperview()
        }
    }
}
