//
//  JPComposeBtn.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/12/6.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit

/// 加号按钮自定义Btn
class JPComposeBtn: UIControl {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    class func composebtn(imageName: String,title: String) -> JPComposeBtn {
        
        let nib = UINib(nibName: "JPComposeBtn", bundle: nil)
        let btn = nib.instantiate(withOwner: nil, options: nil)[0] as! JPComposeBtn
        
        btn.imageView.image = UIImage(named: imageName)
        btn.titleLabel.text = title
        
        return btn
    }
    
}
