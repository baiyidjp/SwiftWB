//
//  Date+Extensions.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/12/15.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import Foundation

/// 日期格式化器
fileprivate let dateFormatter = DateFormatter()

/// 当前日历对象
fileprivate let calendar = Calendar.current

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
    
    /// 将新浪格式的日期转换成date
    ///
    /// - Parameter string: 新浪格式的日期
    /// - Returns: date
    static func jp_sinaDateString(str: String) -> Date? {
        
        //设置日期格式
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss zzz yyy"
        //转换并且返回日期
        return dateFormatter.date(from: str)
    }
    
    /// 返回显示时间本文
    var jp_dateDescription: String {
        
        //判断是否是今天
        if calendar.isDateInToday(self) {
            
            //计算传入 的时间 距离当前时间的差值
            let delta = -Int(self.timeIntervalSinceNow)
            //返回
            if delta < 60 {
                return "刚刚"
            }
            if delta < 60*60 {
                return "\(delta/60)分钟前"
            }
            
            return "\(delta/60*60)小时前"
        }
        //其他天
        var fmt = " HH:mm"
        //是昨天
        if calendar.isDateInYesterday(self) {
            fmt = "昨天"+fmt
        }else {
            //今年
            fmt = "MM-dd"+fmt
            //当前日期所在的年份
            let currentYear = calendar.component(.year, from: Date())
            //传入日期所在的年份
            let year = calendar.component(.year, from: self)
            if year != currentYear {
                //不是今年
                fmt = "yyyy-"+fmt
            }
        }
        //设置日期格式
        dateFormatter.dateFormat = fmt
        return dateFormatter.string(from: self)
    }
    
}
