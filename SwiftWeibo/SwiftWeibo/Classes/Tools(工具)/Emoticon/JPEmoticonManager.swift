
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
    
    /// 表情包 models
    lazy var packagesModels = [JPEmoticonPackages]()
}

// MARK: - 加载表情数据地址
fileprivate extension JPEmoticonManager {
    
    func loadPackages()  {
        
        //读取 emoticons.plist
        guard let path = Bundle.main.path(forResource: "Emoticons.bundle", ofType: nil),
              let bundle = Bundle(path: path),
              let plistPath = bundle.path(forResource: "emoticons.plist", ofType: nil),
              let array = NSArray(contentsOfFile: plistPath) as? [[String:String]],
             let models = NSArray.yy_modelArray(with: JPEmoticonPackages.self, json: array) as? [JPEmoticonPackages]
            else{
                return
        }
        
        packagesModels += models
//        print(packagesModels)
    }
}

// MARK: - 查找表情模型
extension JPEmoticonManager {

    /// 根据传进来的字符串 [爱你] 格式 找到对应的表情模型
    ///
    /// - Parameter string: 传进来的字符串
    /// - Returns: 返回表情模型 有则返回 无则返回nil
    func findEmoticon(string: String) -> JPEmoticonModel? {
        
        //使用过滤方法过滤表情包模型数组
        for package in packagesModels {
            
            //过滤string
            let result = package.emoticons.filter({ (emoticon) -> Bool in
                
                return emoticon.chs == string
            })
            
            //返回模型
            if result.count == 1 {
                return result[0]
            }
        }
        
        return nil
    }
    
    /// 返回完成的图文混排的文本  一定要使用倒叙遍历
    ///
    /// - Parameter string: 传入的原文本
    /// - Returns: 返回
    func emoticonString(string: String,font: UIFont) -> NSAttributedString {
        
        let attribute = NSMutableAttributedString(string: string)
        //创建正则表达式 过滤所有的表情文字
        //[] () 都是正则表达式的关键字 如果要参与匹配 需要用\\转译
        let pattern = "\\[.*?\\]"
        
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []) else {
            
            return attribute
        }
        
        //匹配所有 符合正则的字符
        let result = regx.matches(in: string, options: [], range: NSRange(location: 0, length: attribute.length))
        //遍历 反序
        for match in result.reversed() {
            //取出NSRange
            let range = match.rangeAt(0)
            //取出表情字符串
            let subStr = (attribute.string as NSString).substring(with: range)
            //查找表情模型
            if let em =  JPEmoticonManager.shared.findEmoticon(string: subStr) {
                
                //使用表情图片替换文字
                attribute.replaceCharacters(in: range, with: em.imageText(font: font))
            }
            
        }
        
        //统一设置了属性字符串的属性
        //FIXME: 若不设置 字体大小 则会使布局混乱
        attribute.addAttributes([NSFontAttributeName:font], range: NSRange(location: 0, length: attribute.length))
        
        return attribute
    }

}
