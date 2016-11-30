//
//  JPStatusUserModel.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/11/29.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit

class JPStatusUserModel: NSObject {
    
    /// 用户ID
    var id: Int64 = 0
    /// 用户昵称
    var screen_name: String?
    /// 用户头像地址 50x50
    var profile_image_url: String?
    /// 认证类型 -- -1:没有认证 0:认证用户 2.3.5:企业认证 220:达人
    var verified_type: Int = 0
    /// 会员等级 0-6
    var mbrank: Int = 0
    
    override var description: String {
        
        return yy_modelDescription()
    }
}
