//
//  JPStatusesModel.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/11/23.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit
import YYModel

class JPStatusesModel: NSObject {
    
    /// 当前微博的id Int类型 在64位机器上是64位 在32位机器上是32位 如果不标明Int64 在iPad2/iPhone5/5c/4s/4上都无法正常运行
    var id: Int64 = 0
    /// 微博的信息内容
    var text: String?
    /// 转发数
    var reposts_count: Int = 0
    /// 评论数
    var comments_count: Int = 0
    /// 点赞数
    var attitudes_count: Int = 0
    /// 微博的创建时间
    var created_at: String?
    /// 微博来源
    var source: String?
    
    
    /// 微博用户信息
    var user: JPStatusUserModel?
    /// 配图的数据 数组(model)
    var pic_urls: [JPStatusPicModel]?
    /// 被转发微博的数据
    var retweeted_status: JPStatusesModel?
    
    
    /// 重写 description 的计算型属性
    override var description: String {
        
        return yy_modelDescription()
    }
    
    /// 类函数 告诉第三方框架 数组中存放的什么对象
    ///
    /// - Returns: 字典
    class func modelContainerPropertyGenericClass() -> [String : Any] {
        return ["pic_urls" : JPStatusPicModel.self]
    }
}
