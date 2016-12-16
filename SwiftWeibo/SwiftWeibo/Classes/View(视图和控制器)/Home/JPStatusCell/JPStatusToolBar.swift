//
//  JPStatusToolBar.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/11/30.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit
import SVProgressHUD

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
    
    override func awakeFromNib() {
        
        retweektBtn.addTarget(self, action: #selector(clickRetweekBtn), for: .touchUpInside)
    }
    
    @objc fileprivate func clickRetweekBtn() {
        
        JPNetworkManager.sharedManager.reportOneStatus(id: statusViewModel?.status.id ?? 0) { (data, isSuccess) in
            
            SVProgressHUD.setDefaultStyle(.dark)
            if isSuccess {
                SVProgressHUD.showSuccess(withStatus: "转发成功")
                DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                    SVProgressHUD.setDefaultStyle(.light)
                })
                
            }else {
                SVProgressHUD.showSuccess(withStatus: "转发失败")
                DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                    SVProgressHUD.setDefaultStyle(.light)
                })
            }
        }
    }
}
