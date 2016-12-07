//
//  JPEmoticonPackages.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/12/7.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit
import YYModel

class JPEmoticonPackages: NSObject {
    
    /// 组名
    var groupName: String?
    
    /// 图片所在文件名
    var directory: String?
    
    /// 表情model数组
    lazy var emoticons = [JPEmoticonModel]()
    
    /// 重写 description 的计算型属性
    override var description: String {
        
        return yy_modelDescription()
    }
}
