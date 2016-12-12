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
        NotificationCenter.default.addObserver(self, selector: #selector(textViewTextDidChange), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
        
        setupUI()
    }
    
    @objc fileprivate func textViewTextDidChange() {
        
        placeholderLabel.isHidden = self.hasText
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
