
//
//  JPEmoticonManager.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/12/7.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import Foundation
import YYModel

class JPEmoticonManager {
    
    //单例 管理
    static let shared = JPEmoticonManager()
    
    // 构造函数前面加上 fileprivate 禁止使用构造函数创建实例对象 让使用者必须使用单例
    fileprivate init() {
        loadPackages()
    }
}

// MARK: - 加载表情数据地址
fileprivate extension JPEmoticonManager {
    
    func loadPackages()  {
        
        //读取 emoticons.plist
        guard let path = Bundle.main.path(forResource: "Emoticons.bundle", ofType: nil),
              let bundle = Bundle(path: path),
              let plistPath = bundle.path(forResource: "emoticons.plist", ofType: nil),
              let array = NSArray(contentsOfFile: plistPath) as? [[String:String]]

            else{
                return
        }
        
        print(array)
    }
}
