//
//  JPEmoticonToolView.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/12/13.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit

/// 表情键盘底部的工具栏
class JPEmoticonToolView: UIView {

    override func awakeFromNib() {
        
        setupUI()
    }

}

fileprivate extension JPEmoticonToolView {
    
    /// 设置视图
    func setupUI() {
        
        //从表情管理类中拿到分组名
        let manager = JPEmoticonManager.shared
        
        //按钮的宽度
        let btnW = ScreenWidth / CGFloat(manager.packagesModels.count)
        
        for (i,page) in manager.packagesModels.enumerated() {
            
            let btn = UIButton()
            
            btn.setTitle(page.groupName, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            
            btn.setTitleColor(UIColor.white, for: .normal)
            btn.setTitleColor(UIColor.darkGray, for: .highlighted)
            btn.setTitleColor(UIColor.darkGray, for: .selected)
            
            addSubview(btn)
            
            btn.snp.makeConstraints({ (make) in
                make.top.bottom.equalTo(0)
                make.width.equalTo(btnW)
                make.left.equalTo(CGFloat(i)*btnW)
            })
            
        }
    }
}
