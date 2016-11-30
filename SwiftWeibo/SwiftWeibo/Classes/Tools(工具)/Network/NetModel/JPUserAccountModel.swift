//
//  JPUserAccountModel.swift
//  SwiftWeibo
//
//  Created by Keep丶Dream on 16/11/25.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit

class JPUserAccountModel: NSObject {

    //["expires_in": 157679999, "remind_in": 157679999, "access_token": 2.00s8Kw2C0j6UHJ00a293d906dfn7mC, "uid": 2156431912]
    
    /// 访问令牌
    var access_token: String?
    /// 用户代号
    var uid: String?
    /// access_token的生命周期，单位是秒数。
    var expires_in: TimeInterval = 0 {
        
        didSet {
            expiresDate = Date(timeIntervalSinceNow: expires_in)
        }
    }
    /// 过期日期
    var expiresDate: Date?
    
    /// 用户信息 昵称
    var screen_name: String?
    /// 头像
    var avatar_large: String?
    
    
    
    override var description: String {
        
        return yy_modelDescription()
    }
    
    //重写构造函数
    override init() {
        super.init()
        
        //从磁盘拿出保存的授权信息
        guard let userPath = userAccountPath,
            let jsondata = NSData(contentsOfFile: userPath) ,
            let dict = try? JSONSerialization.jsonObject(with:jsondata as Data , options: []) as? [String: Any]else {
            return
        }
        
        yy_modelSet(with: dict ?? [:])
        
        //token的有效期处理
        guard expiresDate?.compare(Date()) == .orderedDescending else {
            print("TOKEN过期")
            //清除以保存的授权信息
            access_token = nil
            uid = nil
            //删除本地沙盒中保存的授权信息
            try? FileManager.default.removeItem(atPath: userPath)
            return
        }
        
    }
    
    /*
     1.偏好设置
     2.数据库
     3.沙盒
     4.钥匙串访问
     */
    func saveUserAccount() {
        
        //模型转字典
        var dict = (self.yy_modelToJSONObject() as? [String: Any]) ?? [:]
        //删除过期的value
        dict.removeValue(forKey: "expires_in")
        //字典序列化--data
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []),
              let path = userAccountPath
            else {
                return
        }
        //存入磁盘
        (data as NSData).write(toFile: path, atomically: true)

    }
}
