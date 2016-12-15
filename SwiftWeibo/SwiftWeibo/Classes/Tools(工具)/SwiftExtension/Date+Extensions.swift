//
//  Date+Extensions.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/12/15.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import Foundation

fileprivate let dateFormatter = DateFormatter()

extension Date {
    
    //结构体重要定义类似于OC的'类'函数 不在使用class 使用static
    
    /// 用于计算DB的缓存是否过期
    ///
    /// - Parameter max_time: 最大缓存时间
    /// - Returns: 缓存不清除的最早时间 < 这个时间将清除
    static func jp_dateString(max_time: TimeInterval) -> String {
        
        let nowDate = Date(timeIntervalSinceNow: max_time)
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.string(from: nowDate)
    }
}
