//
//  JPHomeNavTitleBtn.swift
//  SwiftWeibo
//
//  Created by Keep丶Dream on 16/11/25.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit

class JPHomeNavTitleBtn: UIButton {

    init(title: String?) {
        
        super.init(frame: CGRect())
        
        if title == nil {
            setTitle("首页", for: .normal)
        }else {
            //加个空格 加个间距
            setTitle(title! + " ", for: .normal)
            setImage(UIImage(named:"navigationbar_arrow_down"), for: .normal)
            setImage(UIImage(named:"navigationbar_arrow_up"), for: .selected)
        }
        //设置字体和颜色
        setTitleColor(UIColor.darkGray, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)

        
        sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        //判断title和image同时存在
        guard let titleLabel = titleLabel,
              let imageView = imageView else {
            return
        }
        //调整title和图片的位置
        titleLabel.frame.origin.x = 0
        imageView.frame.origin.x =  titleLabel.frame.maxX
    }
}
