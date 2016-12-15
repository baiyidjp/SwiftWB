
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
        
        //2.执行SQL 开启事务
        queue.inTransaction { (db, rollBack) in
            
            //遍历数组 逐条插入微博数据
            for dict in array {
                
                //从字典中获取微博代号  将字典序列化成二进制数据
                guard let statusid = dict["idstr"] as? String,
                    let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: [])
                    else {
                        continue
                }
                //执行SQL
                if db?.executeUpdate(sql, withArgumentsIn: [statusid,userid,jsonData]) == false {
                    
                    print("插入失败 需要回滚")
                    //OC 中 *rollBack = yes
                    //Swift 1 2 rollBack.memory = true
                    rollBack?.pointee = true
                    break
                }
            }
        }
    }
    
    
    /// 传入一条SQL 返回 字典数组
    ///
    /// - Parameter sql: sql语句
    /// - Returns: 返回相应的字典数组
    func execRecordSet(sql: String) -> [[String: Any]] {
        
        //要返回的数组
        var result = [[String: Any]]()
        
        //执行SQL -- 查询数据 不用修改数据 所以不用开启事物
        //事务的目的是保证数据的有效性  一旦失败可以回滚
        queue.inDatabase { (db) in
            
            //数据库集合
            guard let rs = db?.executeQuery(sql, withArgumentsIn: []) else {
                return
            }
            //逐行 -- 遍历集合
            while rs.next() {
                
                //列数
                let colCount = rs.columnCount()
                //遍历所有列
                for col in 0..<colCount {
                    
                    //列名--KEY / 值--Value
                    guard let name = rs.columnName(for: col),
                        let value = rs.object(forColumnIndex: col)
                        else {
                            continue
                    }
                    //追加结果
                    result.append([name: value])
                }
            }
        }
        return result
    }
    
    /// 从数据库加载微博数据数组
    ///
    /// - Parameters:
    ///   - userid: 当前登录用户的ID
    ///   - since_id: 返回ID比since_id大的微博 下拉用
    ///   - max_id: 返回ID比max_id小的微博 上拉用
    /// - Returns: 字典数组 需要将status对应的二进制数据反序列化为字典
    func loadStatusFromDB(userid: String,since_id:Int64 = 0,max_id: Int64 = 0) -> [[String: Any]] {
        
        //拼接SQL语句
        var sql = "SELECT statusid,userid,status FROM T_Status \n"
        //查询条件
        sql += "WHERE userid = \(userid) \n"
        //判断是上拉/下拉
        if since_id > 0 {
            sql += "AND statusid > \(since_id) \n"
        }else if max_id > 0 {
            sql += "AND statusid < \(max_id) \n"
        }
        //倒序查询 并且限制条数
        sql += "ORDER BY statusid DESC LIMIT 20;"
        
        print("sql--" + sql)
        return []
    }
}
