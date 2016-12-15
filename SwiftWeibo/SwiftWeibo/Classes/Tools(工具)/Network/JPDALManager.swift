//
//  JPDALManager.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/12/15.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import Foundation

/// DAL - Data Access Layer 数据访问层
/// 使命 负责处理数据库和网络数据 给ListViewModel返回 [字典数组]
class JPDALManager {
    
    /// 从本地数据库或者网络加载数据
    ///
    /// - Parameters:
    ///   - since_id: 下拉刷新ID
    ///   - max_id: 上拉刷新ID
    ///   - completion: 完成回调--微博的字典数组/是否成功
    class func loadStatus(since_id:Int64 = 0,max_id: Int64 = 0, completion:@escaping (_ statuses:[[String: Any]]?,_ isSuccess: Bool)->()) {
        //0.获取用户ID 
        guard let userid = JPNetworkManager.sharedManager.userAccount.uid else {
            return
        }
        //1.检查本地数据 如果有直接返回
        let array = JPSQLiteManager.shared.loadStatusFromDB(userid: userid, since_id: since_id, max_id: max_id)
            //判断数组的数量 没有数据返回的是空数组
        if array.count > 0 {
            completion(array, true)
            return
        }
        //2.加载网络数据
        JPNetworkManager.sharedManager.statusList(since_id: since_id, max_id: max_id) { (status, isSuccess) in
            
            /// 判断网络是否请求成功
            if !isSuccess {
                completion(nil, false)
                return
            }
            //3.加载完网络数据后 将网络数据存储在数据库中
            guard let status = status else {
                completion(nil, isSuccess)
                return
            }
            JPSQLiteManager.shared.updateStatus(userid: userid, array: status)
            //4.返回网络数据
            completion(status,true)
    }

    }
}
