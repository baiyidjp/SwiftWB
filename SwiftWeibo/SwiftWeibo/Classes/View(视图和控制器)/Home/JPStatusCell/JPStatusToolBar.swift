//
//  JPStatusToolBar.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/11/30.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit

class JPStatusToolBar: UIView {
    
    /// 转发
    @IBOutlet weak var retweektBtn: UIButton!
    /// 评论
    @IBOutlet weak var commentBtn: UIButton!
    /// 赞
    @IBOutlet weak var unlikeBtn: UIButton!
    
    /// 单条微博的视图模型
    var statusViewModel: JPStatusViewModel? {
        
        didSet {
            
            retweektBtn.setTitle(" " + (statusViewModel?.retweetStr)!, for: .normal)
            commentBtn.setTitle(" " + (statusViewModel?.commentStr)!, for: .normal)
            unlikeBtn.setTitle(" " + (statusViewModel?.unlikeStr)!, for: .normal)

        }
    }
    
}
