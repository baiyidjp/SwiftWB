//
//  JPEmoticonTipView.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/12/15.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit
import pop

/// 长按表情弹出视图
class JPEmoticonTipView: UIImageView {
    
    //之前选择的表情
    fileprivate var preEmoticonModel: JPEmoticonModel?
    
    //提示视图的模型
    var emoticonModel: JPEmoticonModel? {
        didSet {
            
            if emoticonModel == preEmoticonModel {
                return
            }
            //记录Model
            preEmoticonModel = emoticonModel
            //赋值
            tipButton.setTitle(emoticonModel?.emoji, for: .normal)
            tipButton.setImage(emoticonModel?.image, for: .normal)
            
            //添加pop动画
            let animation: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            
            animation.fromValue = 30
            animation.toValue = 8
            
            animation.springSpeed = 20
            animation.springBounciness = 20
            
            tipButton.layer.pop_add(animation, forKey: nil)
        }
    }
    
    
    fileprivate lazy var tipButton = UIButton()
    
    init() {

        let image = UIImage(named: "emoticon_keyboard_magnifier")
        super.init(image: image)
        //锚点
        layer.anchorPoint = CGPoint(x: 0.5, y: 1.2)
        
        //图片
        tipButton.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        tipButton.frame = CGRect(x: 0, y: 8, width: 36, height: 36)
        tipButton.center.x = bounds.width*0.5
        tipButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        addSubview(tipButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
