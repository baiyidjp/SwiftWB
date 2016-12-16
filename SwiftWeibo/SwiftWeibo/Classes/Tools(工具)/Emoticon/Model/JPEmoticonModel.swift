//
//  JPEmoticonModel.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/12/7.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit
import YYModel

/// 表情模型
class JPEmoticonModel: NSObject {
    
    /// 表情类型 false代表图片表情  true代表emoji表情
    var type = false
    
    /// 表情字符串 发送给你新浪微博 节省流量
    var chs: String?
    
    /// 表情图片名 用于本地的图文混排
    var png: String?
    
    /// 表情所在文件名
    var directory: String?
    
    /// 使用次数
    var times: Int = 0
    
    /// 图片表情对应的图片
    var image: UIImage? {
        
        // 如果是emoji表情 直接return nil
        if type {
            return nil
        }
        
        guard let directory = directory,
            let png = png,
            let path = Bundle.main.path(forResource: "Emoticons.bundle", ofType: nil),
            let bundle = Bundle(path: path)
            else{
                return nil
        }
        
        return UIImage(named: "\(directory)/\(png)", in: bundle, compatibleWith: nil)
    }
    
    /// 将当前的图像转换成图文混排的文本
    func imageText(font: UIFont) -> NSAttributedString {
        
        //判断图片是否存在
        guard let image = image else {
            return NSAttributedString(string: "")
        }
        
        //创建文本附件--图像
        let attachment = JPTextAttachment()
        
        //记录图片名
        attachment.chs = chs
        
        attachment.image = image
        let height = font.lineHeight
        attachment.bounds = CGRect(x: 0, y: -4, width: height, height: height)
        
        //所有的排版系统中 几乎都有一个特点 插入的字符显示都是跟随前一个字符的属性 本身不带属性(此处不处理会导致表情变小)
        let attritubText = NSMutableAttributedString(attributedString: NSAttributedString (attachment: attachment))
        
        attritubText.addAttributes([NSFontAttributeName : font], range: NSRange(location: 0, length: 1))
        
        //返回属性文本--带图
        return attritubText
    }
    
    /// emoji的16进制编码
    var code: String? {
        
        didSet {
            
            guard let code = code else {
                return
            }
            
            let scanner = Scanner(string: code)
            
            var result: UInt32 = 0
            scanner.scanHexInt32(&result)
            
            emoji = String(Character(UnicodeScalar(result)!))
        }
    }
    
    /// emoji的字符串 (表情)
    var emoji: String?
    
    /// 重写 description 的计算型属性
    override var description: String {
        
        return yy_modelDescription()
    }
}
