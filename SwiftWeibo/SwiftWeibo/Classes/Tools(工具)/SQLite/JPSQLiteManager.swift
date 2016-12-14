
//
//  JPSQLiteManager.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/12/14.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import Foundation
import FMDB
/**
    1.数据库本质上是保存在沙盒里的一个文件 首先需要创建并打开数据库
    FMDB - 队列
    2.创建数据表
    3.增删改查
 
    数据库开发程序代码基本都是一致的 区别在于SQL不同
    开发数据库功能时 一定要在Navicat中测试 SQL 的正确性
 */

/// SQLite 管理工具
class JPSQLiteManager {
    
    //单例  全局数据库的访问点
    static let shared = JPSQLiteManager()
    
    let queue: FMDatabaseQueue
    
    
    //私密构造函数 只能调用单例
    fileprivate init() {
        
        let dbName = "Status.db"
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        path = (path as NSString).appendingPathComponent(dbName)
        print("数据库地址--" + path)
        
        // 创建数据库队列 同事 创建/打开 数据库
        queue = FMDatabaseQueue(path: path)
        
        //打开数据库
        creatTable()
    }
}

// MARK: - 创建数据表 及其他私有方法
fileprivate extension JPSQLiteManager {
    
    func creatTable() {
        
        //1.准备SQL
        guard let path = Bundle.main.path(forResource: "status.sql", ofType: nil),
              let sql =  try? String(contentsOfFile: path)
        else {

            return
        }
        
        print(sql)
        //2.执行SQL
        //MARK: --FMDB的内部队列是 串行队列 同步执行
        //可以保证同一时间 只有一个任务在操作数据库 从而保证数据库的读写安全
        queue.inDatabase { (db) in
            
            //只有在创表的使用执行多条语句 可以一次创建多个数据表
            //在执行增删改的时候 一定不能使用 statments 方法 否则可能会被注入
            if db?.executeStatements(sql) == true {
                print("创表Success")
            }else {
                print("创表Failed")
            }
        }
        
        print("Over")
    }
    
}

// MARK: - 微博数据操作
extension JPSQLiteManager {
    
    /// 新增或者修改微博数据
    ///
    /// - Parameters:
    ///   - userid: 用户ID
    ///   - array: 网络返回的[字典数组]
    func updateStatus(userid: String,array: [[String: Any]]) {
        
        //1.准备SQL
        /**
            statusid:   要保存的微博代号
            userid:     当前登录用户的iD
            status:     完整微博字典的json的二进制数据
         */
        let sql = "INSERT OR REPLACE INTO T_Status (statusid,userid,status) VALUES(?,?,?)"
        
    }
}
