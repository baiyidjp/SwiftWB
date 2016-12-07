//
//  String+Extensions.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/12/7.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import Foundation

extension String {
    
    /// 返回值可以是多个  swift中的元组  在OC中可以使用字典
    func jp_hrefSource() -> (link: String,text: String)? {
        
        //1- 匹配方案
        let pattern = "<a href=\"(.*?)\".*?>(.*?)</a>"
        
        //2- 创建正则表达式
        
        guard let regular = try? NSRegularExpression(pattern: pattern, options: []),
              let result = regular.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.characters.count))
        else {
            return nil
        }
        
        //3- 获取结果
        let link = (self as NSString).substring(with: result.rangeAt(1))
        let text = (self as NSString).substring(with: result.rangeAt(2))
        
        return(link,text)
    }
}
