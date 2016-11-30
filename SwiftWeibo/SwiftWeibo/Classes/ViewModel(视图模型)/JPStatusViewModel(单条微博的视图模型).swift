//
//  JPStatusViewModel.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/11/29.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import Foundation

/// 单条微博的视图模型
class JPStatusViewModel: CustomStringConvertible {
    
    /// 微博模型
    var status: JPStatusesModel
    /// 会员图标
    var memberImage: UIImage?
    /// 认证图标  -1:没有认证 0:认证用户 2.3.5:企业认证 220:达人
    var verifiedImage: UIImage?
    /// 转发 评论 赞
    var retweetStr: String?
    var commentStr: String?
    var unlikeStr: String?
    
    /// 配图大小
    var pictureViewSize = CGSize()
    /// 如果是被转发的微博  原创微博一定没有图
    var picURLs: [JPStatusPicModel]? {
        //如果没有被转发微博 返回原创微博的图片
        return status.retweeted_status?.pic_urls ?? status.pic_urls
    }
    /// 被转发微博的文本
    var retweetText: String?
    
    /// 构造函数
    /// - Parameter model: 微博模型
    init(model: JPStatusesModel) {
        self.status = model
        /// 会员等级 0-6  common_icon_membership_level1
        if (model.user?.mbrank)! > 0 && (model.user?.mbrank)! < 7 {
            let imageName = "common_icon_membership_level\(model.user?.mbrank ?? 1)"
            self.memberImage = UIImage(named: imageName)
        }
        
        switch model.user?.verified_type ?? -1 {
        case 0:
            verifiedImage = UIImage(named: "avatar_vip")
        case 2 , 3 , 5:
            verifiedImage = UIImage(named: "avatar_enterprise_vip")
        case 0:
            verifiedImage = UIImage(named: "avatar_grassroot")
        default:
            break
        }
        //设置底部bar
        retweetStr = countString(count: status.reposts_count, defaultStr: "转发")
        commentStr = countString(count: status.comments_count, defaultStr: "评论")
        unlikeStr = countString(count: status.attitudes_count, defaultStr: "赞")
        
        //计算图片view的size  (有转发的时候使用转发)
        pictureViewSize = pictureSize(picCount: picURLs?.count)
        
        //被转发微博的文字
        retweetText = "@" + (status.retweeted_status?.user?.screen_name ?? "") + ":" + (status.retweeted_status?.text ?? "")
    }
    
    var description: String {
        
        return status.description
    }
    
    /// 将数字转换为描述结果
    ///
    /// - Parameters:
    ///   - count: 数字
    ///   - default: 默认字符串
    /// - Returns: 结果
    fileprivate func countString(count: Int,defaultStr: String) -> String {
        /*
         count == 0 默认字符串
         count < 10000 实际数值
         count >= 10000 xxx万
         */
        
        if count == 0 {
            return defaultStr
        }
        if count < 10000 {
            return count.description
        }
        
        return String(format: "%.02f万", Double(count)/10000)
    }
    
    /// 根据图片的数量 计算配图view的size
    ///
    /// - Parameter picCount: 配图数量
    /// - Returns: view的size
    fileprivate func pictureSize(picCount: Int?) -> CGSize {
        
        if picCount == 0 || picCount == nil {
            return CGSize(width: 0, height: 0)
        }
        //计算行数
        let row = (picCount! - 1) / 3 + 1
        //计算高度
        let pictureViewHeight = JPStatusPicOutterMargin + CGFloat(row) * JPStatusPictureWidth + CGFloat(row-1)*JPStatusPicIntterMargin
        
        return CGSize(width: JPStatusPictureViewWidth, height: pictureViewHeight)
    }
}
