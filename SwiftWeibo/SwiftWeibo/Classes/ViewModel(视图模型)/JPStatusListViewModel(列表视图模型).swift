//
//  JPStatusListViewModel.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/11/23.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit
import SDWebImage

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
                
                self.cacheSingleImage(statusViewModels: statusViewModels, finished: completion)
                
                /// 完成回调 -- 应该是在所有单张图片缓存完成后再回调
//                completion(isSuccess,true)
            }
            
        }
    }
    
    /// 缓存当前请求回来的微博数据中的 单张图片
    ///
    /// - Parameter statusViewModels: 当前请求回来的微博的viewmodle列表
    fileprivate func cacheSingleImage(statusViewModels: [JPStatusViewModel], finished: @escaping (_ isSuccess: Bool,_ isReloadData: Bool)->()) {
        
        //创建调度组
        let group = DispatchGroup()
        
        
        //总图片的大小
        var imageData = 0
        
        //遍历数组 找出微博数据中 图片是单张的微博数据
        for viewModel in statusViewModels {
            
            //判断图片数量
            if viewModel.picURLs?.count != 1 {
                continue
            }
            
            //获取图像模型
            guard let picUrl = viewModel.picURLs?[0].thumbnail_pic,
                  let url = URL(string: picUrl)
            else {
                continue
            }
            
            //入组(会监听最近的一个block/闭包 必须和出组配合使用)
            group.enter()
            
            //下载图片
            //SDWebImage的核心下载方法 图片下载完成后会缓存在沙盒中 名字是地址的MD5
            SDWebImageManager.shared().downloadImage(with: url, options: [], progress: nil, completed: { (image, _, _, _, _) in
                
                if let image = image,
                    let data = UIImagePNGRepresentation(image) {
                    
                    imageData += data.count
                    
                    print("缓存的图像是--- \(image) 大小--\(imageData)")
                    //更新单条微博viewmodel中的配图的size
                    viewModel.updatePicViewSizeWithImage(image: image)
                }
                
                //出组 (一定要闭包的最后一句)
                group.leave()
            })
        }
        
        //监听调度组
        group.notify(queue: DispatchQueue.main) {
            
            print("图像缓存完成---\(imageData/1024)K")
            /// 完成回调 -- 应该是在所有单张图片缓存完成后再回调
            finished(true,true)
        }
    }
}
