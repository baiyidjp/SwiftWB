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
            
            btn.setTitleColor(UIColor.darkGray, for: .normal)
            btn.setTitleColor(UIColor.white, for: .highlighted)
            btn.setTitleColor(UIColor.white, for: .selected)
            
            addSubview(btn)
            
            //设置按钮图片
            let imageNormalName = "compose_emotion_table_\(page.bgImageName ?? "")_normal"
            let imageSelectesName = "compose_emotion_table_\(page.bgImageName ?? "")_selected"
            
            var imageNormal = UIImage(named: imageNormalName)
            var imageSelected = UIImage(named: imageSelectesName)
            
            //图片的大小
            let imageSize = imageNormal?.size ?? CGSize()
            let inset = UIEdgeInsets(top: imageSize.height*0.5, left: imageSize.width*0.5, bottom: imageSize.width*0.5, right: imageSize.height*0.5)
            
            imageNormal = imageNormal?.resizableImage(withCapInsets: inset, resizingMode: .stretch)
            imageSelected = imageSelected?.resizableImage(withCapInsets: inset, resizingMode: .stretch)
            
            btn.setBackgroundImage(imageNormal, for: .normal)
            btn.setBackgroundImage(imageSelected, for: .selected)
            
            btn.snp.makeConstraints({ (make) in
                make.top.bottom.equalTo(0)
                make.width.equalTo(btnW)
                make.left.equalTo(CGFloat(i)*btnW)
            })
            
        }
    }
}
