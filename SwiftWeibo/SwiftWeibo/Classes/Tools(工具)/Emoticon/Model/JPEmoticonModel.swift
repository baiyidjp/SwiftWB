//
//  JPEmoticonModel.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/12/7.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit
import YYModel

/// 表情模型
class JPEmoticonModel: NSObject {
    
    /// 表情类型 false代表图片表情  true代表emoji表情
    var type = false
    
    /// 表情字符串 发送给你新浪微博 节省流量
    var chs: String?
    
    /// 表情图片名 用于本地的图文混排
    var png: String?
    
    /// emoji的16进制编码
    var code: String?
    
    /// 重写 description 的计算型属性
    override var description: String {
        
        return yy_modelDescription()
    }
}
