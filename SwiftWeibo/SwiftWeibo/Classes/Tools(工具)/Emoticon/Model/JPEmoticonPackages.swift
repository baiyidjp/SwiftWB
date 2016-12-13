//
//  JPEmoticonPackages.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/12/7.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit
import YYModel

class JPEmoticonPackages: NSObject {
    
    /// 组名
    var groupName: String?
    
    /// 背景图片名
    var bgImageName: String?
    
    /// 图片所在文件名
    var directory: String? {
        
        /// 使用didSet直接加载出表情模型数组
        didSet {
            guard let directory = directory,
                let path = Bundle.main.path(forResource: "Emoticons.bundle", ofType: nil),
                let bundle = Bundle(path: path),
                let plistPath = bundle.path(forResource: "info.plist", ofType: nil, inDirectory: directory),
                let array = NSArray(contentsOfFile: plistPath) as? [[String:String]],
                let models = NSArray.yy_modelArray(with: JPEmoticonModel.self, json: array) as? [JPEmoticonModel]
                else{
                    return
                }
            
            //遍历models 设置每一个 表情的 目录地址
            for model in models {
                model.directory  = directory
            }
            
            emoticons += models

        }
    }
    
    /// 表情model数组
    lazy var emoticons = [JPEmoticonModel]()
    
    /// 每一组下的页面数
    var numOfPages: Int {
        
        return (emoticons.count - 1) / 20 + 1
    }
    
    /// 根据传进来的页数返回当前页面的表情数组
    ///
    /// - Parameter page: 页数
    /// - Returns: 数组
    func subEmoticons(page: Int) -> [JPEmoticonModel] {
        
        //常量
        let count = 20
        let location = page*count
        var length = count
        //最后一页不足20个时
        if location+length > emoticons.count {
            length = emoticons.count - location
        }
        
        //计算需要截取的Range
        let range = NSRange(location: location, length: length)
        
        //截取表情数组的子数组
        let array = (emoticons as NSArray).subarray(with: range) as! [JPEmoticonModel]
        
        return array
    }
    
    /// 重写 description 的计算型属性
    override var description: String {
        
        return yy_modelDescription()
    }
}
