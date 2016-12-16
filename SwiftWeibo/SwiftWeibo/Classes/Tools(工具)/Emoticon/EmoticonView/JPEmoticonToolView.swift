//
//  JPEmoticonToolView.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/12/13.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit

/// 代理/协议
@objc protocol JPEmoticonToolViewDelegate: NSObjectProtocol {
    
    func emoticonToolBarItemDidSelectIndex(toolView: JPEmoticonToolView,index: Int)
}

/// 表情键盘底部的工具栏
class JPEmoticonToolView: UIView {

    override func awakeFromNib() {
        
        setupUI()
    }
    
    weak var delegate: JPEmoticonToolViewDelegate?
    
    /// 滚动时 调整按钮的点击状态
    var selectIndex: Int = 0 {
        
        didSet {
            
            for btn in subviews as! [UIButton] {
                
                setButton(isSelect: btn.tag == selectIndex, btn: btn)
            }
        }
    }
    
    
    /// 点击底部的item
    ///
    /// - Parameter button: 按钮
    @objc fileprivate func clickItem(button: UIButton) {
        
        for btn in subviews as! [UIButton] {
            
            setButton(isSelect: btn == button, btn: btn)
        }
        
        delegate?.emoticonToolBarItemDidSelectIndex(toolView: self, index: button.tag)
    }
    
    fileprivate func setButton(isSelect: Bool,btn: UIButton) {
        
        btn.isSelected = isSelect
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

            //设置按钮图片 compose_emotion_table_left_normal  compose_emotion_table_mid_selected
            var imageNormal = UIImage(named: "compose_emotion_table_\(page.bgImageName ?? "")_normal")
            var imageSelected = UIImage(named: "compose_emotion_table_\(page.bgImageName ?? "")_selected")
            
            //图片的大小
            let imageSize = imageNormal?.size ?? CGSize()
            let inset = UIEdgeInsets(top: imageSize.height*0.5, left: imageSize.width*0.5, bottom: imageSize.width*0.5, right: imageSize.height*0.5)
            
            imageNormal = imageNormal?.resizableImage(withCapInsets: inset, resizingMode: .stretch)
            imageSelected = imageSelected?.resizableImage(withCapInsets: inset, resizingMode: .stretch)
            
            btn.setBackgroundImage(imageNormal, for: .normal)
            btn.setBackgroundImage(imageSelected, for: .highlighted)
            btn.setBackgroundImage(imageSelected, for: .selected)
            
            addSubview(btn)
            
            btn.snp.makeConstraints({ (make) in
                make.top.bottom.equalTo(0)
                make.width.equalTo(btnW)
                make.left.equalTo(CGFloat(i)*btnW)
            })
            
            //设置tag值
            btn.tag = i
            //添加点击方法
            btn.addTarget(self, action: #selector(clickItem), for: .touchUpInside)

        }
        //第一个按钮默认点击
        (subviews[0] as! UIButton).isSelected = true
    }
}
