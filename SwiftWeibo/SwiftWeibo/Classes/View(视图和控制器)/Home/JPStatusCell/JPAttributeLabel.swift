//
//  JPAttributeLabel.swift
//  SwiftWeibo
//
//  Created by Keep丶Dream on 16/12/8.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit

/**
    1.使用textKit接管UILabel的底层实现 -- 只要是绘制 textStorage 的文本
    2.使用正则表达式过滤URL
    3.交互
 */


/// 点击内容代理/协议
@objc protocol JPAttributeLabelDelegate: NSObjectProtocol {
    
    @objc optional func labelDidSelectedLinkText(label: JPAttributeLabel, text: String)
}


class JPAttributeLabel: UILabel {

    var linkTextColor = UIColor.blue
    var selectedBackgroudColor = UIColor.lightGray
    var delegate: JPAttributeLabelDelegate?
    
    //MARK: -textKit的核心对象
    /// 属性文本存储
    fileprivate var textStorage = NSTextStorage()
    /// 负责'字形'布局
    fileprivate var layoutManager = NSLayoutManager()
    /// 设定文本绘制的范围
    fileprivate var textContainer = NSTextContainer()
    /// 选中的范围
    fileprivate var selectedRange: NSRange?
    
    /// 重写属性 重新接管 label
    override var text: String? {
        
        didSet {
            //当text内容变化 重新设置 textStorage
            prepareTextSystem()
        }

    }
    override var attributedText: NSAttributedString? {
        
        didSet {
            //当text内容变化 重新设置 textStorage
            prepareTextSystem()
        }

    }
    
    override var font: UIFont! {
        didSet {
            //当text内容变化 重新设置 textStorage
            prepareTextSystem()
        }
    }
    
    override var textColor: UIColor! {
        didSet {
            //当text内容变化 重新设置 textStorage
            prepareTextSystem()
        }

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 指定绘制文本的区域
        textContainer.size = bounds.size
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareTextSystem()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepareTextSystem()
    }
    
    //MARK: - 绘制文本
    // ios中的绘制工作类似于油画  后绘制的内容会把之前的内容覆盖 所有需要先绘制背景在绘制字形
    // 避免使用带透明的颜色 严重影响性能
    override func drawText(in rect: CGRect) {
        
        let range = NSRange(location: 0, length: textStorage.length)
        
        //绘制背景
        layoutManager.drawBackground(forGlyphRange: range, at: CGPoint())
        //绘制字形 'Glyphs'-字形   CGPoint()顶部对齐
        layoutManager.drawGlyphs(forGlyphRange: range, at: CGPoint())
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //获取用户当前的点击位置
        guard let location = touches.first?.location(in: self) else {
            return
        }
        
        //获取当前用户点击的字符索引
        let index = layoutManager.glyphIndex(for: location, in: textContainer)
        
        //判断index是否是在URL的range内
        for range in linkRanges ?? [] {
            
            if NSLocationInRange(index, range) {
                
                //记录当前点中的 range
                selectedRange = range
                //需要设置背景色
                textStorage.addAttributes([NSBackgroundColorAttributeName : selectedBackgroudColor], range: range)
                //重绘
                setNeedsDisplay()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if selectedRange == nil {
            return
        }
        
        //取消背景色
        DispatchQueue.main.asyncAfter(deadline: .now()+0.25, execute: {
            self.textStorage.addAttributes([NSBackgroundColorAttributeName : UIColor.clear], range: self.selectedRange!)
            //重绘
            self.setNeedsDisplay()
            
            //发送代理
            let text = (self.textStorage.string as NSString).substring(with: self.selectedRange!)
            //插入? 如果代理没实现 则什么都不做 不能使用!
            self.delegate?.labelDidSelectedLinkText?(label: self, text: text)

        })
        
    }
}

// MARK: - 设置textKit的核心对象
fileprivate extension JPAttributeLabel {
    
    /// 准备文本系统
    func prepareTextSystem() {
        
        //开启用户交互
        isUserInteractionEnabled = true
        //准备文本内容
        prepareTextContent()
        //设置对象的关系
        // 先移除后添加 否则会崩溃
        textStorage.removeLayoutManager(layoutManager)
        
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        //此句代码不加会导致布局混乱 起始位置设置在0
        textContainer.lineFragmentPadding = 0
    }
    
    /// 准备文本 使用textStorage 接管 label
    func prepareTextContent() {
        
        if let attributedText = attributedText {
            textStorage.setAttributedString(attributedText)
        }else if let text = text {
            textStorage.setAttributedString(NSAttributedString(string: text))
        }else {
            textStorage.setAttributedString(NSAttributedString(string: ""))
        }
        
        /// 设置文本的属性 - URL高亮
        for range in linkRanges ?? [] {
            
            textStorage.addAttributes([NSForegroundColorAttributeName : linkTextColor],range: range)
        }
    }
}

// MARK: - 正则表达式函数
fileprivate extension JPAttributeLabel {

    /// 返回文本中的 需要高亮的 range 数组
    var linkRanges: [NSRange]? {
        
        var ranges = [NSRange]()

        //正则表达式 匹配 url #话题# @xxx
        let patterns = ["[a-zA-Z]*://[a-zA-Z0-9/\\.]*", "#.*?#", "@[\\u4e00-\\u9fa5a-zA-Z0-9_-]*"]
        
        for pattern in patterns {
            
            guard let regx = try? NSRegularExpression(pattern: pattern, options: []) else {
                
                return []
            }
            
            //多重匹配
            let matches = regx.matches(in: textStorage.string, options: [], range: NSRange(location: 0, length: textStorage.length))
            
            //生成数组
            
            for match in matches {
                let range = match.rangeAt(0)
                ranges.append(range)
            }
            
        }
        return ranges
    }
}
