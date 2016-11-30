//
//  JPNetworkManager.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/11/23.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit
import AFNetworking


/// Swift枚举
/// 支持任意类型
enum JPHTTPMethod {
    case GET
    case POST
}

/// 网络管理工具
class JPNetworkManager: AFHTTPSessionManager {
    
    /// swift中的单例
    /// 静态区/常量/闭包
    /// 第一次访问时执行闭包 并且将结果保存在 sharedManager 常量中
    static let sharedManager: JPNetworkManager = {
        
        let instance = JPNetworkManager()
        
        //设置AFN反序列化支持
        instance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        return instance
        
    }()
    
    /// 懒加载授权信息的Model
    lazy var userAccount = JPUserAccountModel()
    
    /// 计算型属性 判断是否登录成功
    var userLogon: Bool {
        
        return userAccount.access_token != nil
    }
    
    
    /// 自带token的网络请求 不需要另外传入token
    func tokenRequest(method: JPHTTPMethod = .GET,URLString: String,parameters: [String: Any]?,completion:@escaping (_ data: Any?,_ isSuccess: Bool)->()) {
        //判断是否存在token
        guard userAccount.access_token != nil else {
            
            //发送通知--通知用户登录
            print("token不存在 请先登录")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: JPUserShouldLoginNotification), object: nil)
            completion(nil, false)
            return
        }
        //先将字典变为变量
        var parameters = parameters
        if parameters == nil {
            //如果为空 新建
            parameters = [String: Any]()
        }
        //直接在此方法中将token加入字典
        parameters!["access_token"] = userAccount.access_token
        //请求封装的接口
        request(URLString: URLString, parameters: parameters, completion: completion)
    }
    
    /// 封装AFN GET/POST 请求接口
    ///
    /// - Parameters:
    ///   - method: HTTP请求方式
    ///   - URLString: 请求地址
    ///   - parameters: 请求参数
    ///   - completion: 成功/失败 回调
    func request(method: JPHTTPMethod = .GET,URLString: String,parameters: [String: Any]?,completion:@escaping (_ data: Any?,_ isSuccess: Bool)->()) {
        
        //成功闭包
        let success = { (task: URLSessionDataTask, data: Any?)->() in
            completion(data, true)
        }
        //失败闭包
        let failure = { (task: URLSessionDataTask?, error: Error)->() in
            
            if (task?.response as? HTTPURLResponse)?.statusCode == 403 {
                // 发送通知--通知用户登录
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: JPUserShouldLoginNotification), object: "token timeout")
                print("token过期了 请先登录")
            }
            
            completion(nil, false)
        }
        //将闭包作为一个参数传入AFN
        if method == .GET {
            get(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }else{
            post(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }
    }
}
