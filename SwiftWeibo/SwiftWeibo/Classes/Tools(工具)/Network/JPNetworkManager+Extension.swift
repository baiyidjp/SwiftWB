//
//  JPNetworkManager+Extension.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/11/23.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import Foundation


// MARK: - 封装微博用的网络请求
extension JPNetworkManager {
    
    /// 请求微博首页 微博列表数据
    ///   - since_id: 若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
    ///   - max_id: 若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
    /// - Parameter completion: 回调(statuses--微博数据 )
    func statusList(since_id:Int64 = 0,max_id: Int64 = 0, completion:@escaping (_ statuses:[[String: Any]]?,_ isSuccess: Bool)->()) {
        
        let URL = "https://api.weibo.com/2/statuses/home_timeline.json"
        // 返回ID小于或等于max_id的微博 所以上拉将ID减一
        let params = ["since_id" : "\(since_id)","max_id": "\(max_id > 0 ? max_id - 1 : 0)"]
        
        tokenRequest(URLString: URL, parameters: params) { (data, isSuccess) in

            let dict = data as? [String: Any]
            let statuses = dict?["statuses"] as? [[String: Any]]
            completion(statuses, isSuccess)

        }

    }
    
    func unreadCount(completion: @escaping (_ unreadCount: Int)->()) {
        
        guard userAccount.uid != nil else {
            return
        }
        let URL = "https://rm.api.weibo.com/2/remind/unread_count.json"
        let params = ["uid": userAccount.uid]
        
        tokenRequest(URLString: URL, parameters: params) { (data, isSuccess) in
            
            let dict = data as? [String: Any]
            let count = dict?["status"] as? Int
            completion(count ?? 0)
        }
    }
    

}

// MARK: - OAuth请求
extension JPNetworkManager {
    
    func getToken(code: String,completion: @escaping (_ isSuccess: Bool)->()) {
        
        let URL = "https://api.weibo.com/oauth2/access_token"
        
        let params = ["client_id": SinaClient_id,
                      "client_secret": SinaAppSecret,
                      "grant_type": "authorization_code",
                      "code": code,
                      "redirect_uri": SinaRedirect_uri
                      ]
        
        request(method: .POST, URLString: URL, parameters: params) { (data, isSuccess) in
            
            let dict = data as? [String: Any]

            self.userAccount.yy_modelSet(with: dict ?? [:])

            //加载个人信息
            self.loadUserInfo(completion: { (dict) in
                //将头像和昵称转模型
                self.userAccount.yy_modelSet(with: dict)
                //保存信息到磁盘
                self.userAccount.saveUserAccount()
                //加载完个人信息在进行回调
                completion(isSuccess)
            })
            
        }

    }
}

// MARK: - 加载用户信息
extension JPNetworkManager {
    
    /// 加载个人信息
    func loadUserInfo(completion: @escaping (_ dict: [String: Any])->()) {
        
        guard let uid = userAccount.uid else {
            return
        }
        
        let strUrl = "https://api.weibo.com/2/users/show.json"
        let params = ["uid": uid]
        
        tokenRequest(URLString: strUrl, parameters: params) { (data, isSuccess) in
            
            completion((data as? [String: Any]) ?? [:])
        }
    }
}

// MARK: - 发布微博
extension JPNetworkManager {

    func postStatus(text: String,completion:@escaping (_ result:[String: Any]?,_ isSuccess: Bool)->()) -> () {
        
        let urlStr = "https://api.weibo.com/2/statuses/update.json"
        
        let params = ["status": text]
        
        tokenRequest(method: .POST, URLString: urlStr, parameters: params ) { (data, isSuccess) in
        
            completion(data as? [String: Any], isSuccess)
        }
        
    }
}
