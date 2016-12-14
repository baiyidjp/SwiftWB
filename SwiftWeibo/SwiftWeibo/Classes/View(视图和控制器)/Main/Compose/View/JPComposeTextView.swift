//
//  JPComposeTextView.swift
//  SwiftWeibo
//
//  Created by Keep丶Dream on 16/12/12.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit

class JPComposeTextView: UITextView {

    /// 占位符
    fileprivate lazy var placeholderLabel = UILabel()
    
    override func awakeFromNib() {
        
        //注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(textViewTextDidChange), name: NSNotification.Name.UITextViewTextDidChange, object: self)
        
        setupUI()
    }
    /// 占位符的显示与消失
    @objc fileprivate func textViewTextDidChange() {
        
        placeholderLabel.isHidden = self.hasText
    }
    
    deinit {
        //移除通知
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - 设置UI
fileprivate extension JPComposeTextView {
    
    func setupUI() {
        
        placeholderLabel.text = "分享新鲜事..."
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.frame.origin = CGPoint(x: 5, y: 8)
        placeholderLabel.sizeToFit()
        
        addSubview(placeholderLabel)
        
    }
}

//MARK: - 表情键盘与textView结合方法
extension JPComposeTextView {
    
    /// 插入表情(图文混排)
    ///
    /// - Parameter emoticonModel: nil为删除键
    func insertEmoticon(emoticonModel:JPEmoticonModel?) {
        
        //若为nil 删除
        guard let emoticonModel = emoticonModel else {
            
            deleteBackward()
            return
        }
        
        //是否是emoji 字符串
        if let emoji = emoticonModel.emoji,
            let textRange = selectedTextRange {
            
            //插入emoji字符串
            replace(textRange, withText: emoji)
            return
        }
        
        //走到此处 都是图片表情
        //1-拿到图片表情对应的属性文本
        let imageText = emoticonModel.imageText(font: font!)
        
        //2-使用当前textview的文本内容创建一个新的属性文本 用来接收图片的属性文本
        let attributeText = NSMutableAttributedString(attributedString: attributedText)
        
        //3-更新属性文本
        //记录当前鼠标的位置
        let range = selectedRange
        //插入表情文本
        attributeText.replaceCharacters(in: range, with: imageText)
        
        //4-恢复文本 光标位置
        attributedText = attributeText
        //range的length是选中的文本的长度 重新设置时应该为0
        selectedRange = NSRange(location: range.location+1, length: 0)
        
        //5-让代理执行(解决占位符不消失)
        delegate?.textViewDidChange?(self)
        textViewTextDidChange()
    }
    
    /// 将textview的属性文本 转换成 纯 文字的文本
    ///
    /// - Returns: 纯文字的文本
    func emoticonStringText() -> String {
        
        //用来接收转换的文本
        var resultText = String()
        
        //获取textview的属性文本
        guard let attritubeText = attributedText else {
            return resultText
        }
        //遍历属性文本
        attritubeText.enumerateAttributes(in: NSRange(location: 0, length: (attritubeText.length)), options: [], using: { (dict, range, _) in
            
            //表情字符的 dict 中 存在 NSAttachment 便是表情字符
            if let textAttachment = dict["NSAttachment"] {
                resultText += (textAttachment as! JPTextAttachment).chs ?? ""
            }else {
                let subStr = (attritubeText.string as NSString).substring(with: range)
                resultText += subStr
            }
        })
        print(resultText)
        return resultText
    }

}
