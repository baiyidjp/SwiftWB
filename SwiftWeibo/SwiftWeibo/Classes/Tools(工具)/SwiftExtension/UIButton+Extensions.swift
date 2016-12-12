
//
//  UIButton+Extensions.swift
//  SwiftWeibo
//
//  Created by Keep丶Dream on 16/11/19.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit


extension UIButton {
    
    
    /// 自定义Button
    ///
    /// - Parameters:
    ///   - title: 文本
    ///   - fontSize: 字号
    ///   - normalColor: 默认文字颜色
    ///   - highlightColor: 高亮的文字颜色
    convenience init(title: String,fontSize: CGFloat = 16,normalColor: UIColor = UIColor.black,highlightColor: UIColor = UIColor.orange,backgroundImageName: String = "") {
        
        self.init()
        
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        self.setTitleColor(normalColor, for: .normal)
        self.setTitleColor(highlightColor, for: .highlighted)
        self.setBackgroundImage(UIImage(named: backgroundImageName), for: .normal)
        self.setBackgroundImage(UIImage(named: backgroundImageName + "_highlighted"), for: .highlighted)
        self.sizeToFit()
    }
    
    
}

extension UIButton {
    
    convenience init(imageName: String,backgroundImageName: String = " " ,highlightName: String) {
        
        self.init()
        self.setImage(UIImage(named: imageName), for: .normal)
        self.setBackgroundImage(UIImage(named: backgroundImageName), for: .normal)
        self.setImage(UIImage(named: imageName+highlightName), for: .highlighted)
        self.setBackgroundImage(UIImage(named: backgroundImageName+highlightName), for: .highlighted)
        self.sizeToFit()
    }
    
}

