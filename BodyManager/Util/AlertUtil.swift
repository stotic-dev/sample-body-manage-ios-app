//
//  AlertUtil.swift
//  BodyManager
//
//  Created by 佐藤汰一 on 2021/11/12.
//

import Foundation
import SwiftMessages

class AlertUtil {
    
    static func errorAlert(body:String) {
        let view = MessageView.viewFromNib(layout: .messageView)
        view.configureTheme(.error)
        view.configureDropShadow()
        view.button?.isHidden = true

        view.configureContent(body: body)
        view.titleLabel?.text = "エラー"
        
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
        
        var config = SwiftMessages.Config()
        config.dimMode = .none
        
        SwiftMessages.show(config: config, view: view)
    }
    
}
