
//
//  UILable+Extensions.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/11/21.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit

extension UILabel {
    
    convenience init(text: String , fontSize: CGFloat = 15 ,textColor: UIColor ,textAlignment: NSTextAlignment = .center) {
        self.init()
        
        self.text = text
        self.font = UIFont.systemFont(ofSize: fontSize)
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.sizeToFit()
    }
}
