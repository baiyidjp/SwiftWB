
//
//  UIBarButtonItem+Extensions.swift
//  SwiftWeibo
//
//  Created by Keep丶Dream on 16/11/19.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    
    /// 创建自定义UIBarButtonItem
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - fontSize: 字号 默认15
    ///   - target: target description
    ///   - action: action description
    ///   - isBackButton: 是否是返回按钮
    convenience init(title: String, fontSize: CGFloat = 16, target: Any, action: Selector, isBackButton: Bool = false) {
        
        let btn = UIButton(title: title)
        
        if isBackButton {
            
            let imageName = "navigationbar_back_withtext"
            btn.setImage(UIImage(named: imageName), for: .normal)
            btn.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
            btn.sizeToFit()
        }
        
        btn.addTarget(target, action: action, for: .touchUpInside)
        
        //实例化 UIBarButtonItem
        self.init(customView: btn)
    }
}
