//
//  JPStatusListViewModel.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/11/23.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit

//刷新失败最大次数
fileprivate let reloadFailedMaxTime = 3

/// ViewModel 处理网络请求数据  刷新
class JPStatusListViewModel: NSObject {
    
    /// 刷新失败的当前次数
    fileprivate var reloadFailesTimes = 0
    
    /// 微博model数组
    lazy var statusList = [JPStatusViewModel]()

    /// 加载微博列表数据
    /// - isPullup 是否是上啦刷新
    /// - Parameter completion: 是否成功的回调
    func loadStatusList(isPullup: Bool, completion: @escaping (_ isSuccess: Bool,_ isReloadData: Bool)->()) {
        
        if isPullup && reloadFailesTimes == reloadFailedMaxTime {
            print("次数上限")
            completion(true, false)
            return
        }
        
        // 取出数组的第一条数据的ID 作为下拉刷新的参数
        let since_id = isPullup ? 0 : (statusList.first?.status.id ?? 0)
        // 取出数组的第一条数据的ID 作为下拉刷新的参数
        let max_id = isPullup ? (statusList.last?.status.id ?? 0) : 0
        
        JPNetworkManager.sharedManager.statusList(since_id: since_id, max_id: max_id) { (status, isSuccess) in
            
            /// 判断网络是否请求成功
            if !isSuccess {
                completion(false, false)
                return
            }
            /// 字典转模型
            guard let array = NSArray.yy_modelArray(with: JPStatusesModel.self, json: status ?? []) as? [JPStatusesModel] else {
                return
            }
            // 视图模型集合
            var statusViewModels = [JPStatusViewModel]()
            for statusModel in array {
                
                let statusViewModel = JPStatusViewModel(model: statusModel)
                statusViewModels.append(statusViewModel)
            }
            print("model数据--\(array)")
            /// 闭包中使用 self 拼接数组 
            /// 下拉刷新 最新的拼接到前面
            if isPullup {
                print("上拉刷新 \(array.count) 数据")
                self.statusList += statusViewModels
            }else{
                print("下拉刷新 \(array.count) 数据")
                self.statusList = statusViewModels + self.statusList
            }
            
            if isPullup && array.count == 0 {
                self.reloadFailesTimes += 1
                completion(isSuccess, false)
            }else{
                /// 完成回调
                completion(isSuccess,true)
            }
            
        }
    }
    
}
