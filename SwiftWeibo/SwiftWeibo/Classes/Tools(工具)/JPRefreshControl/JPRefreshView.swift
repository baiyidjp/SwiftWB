//
//  JPRefreshView.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/12/5.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit

class JPRefreshView: UIView {
    
    /// 刷新图片
    lazy var tipIcon = UIImageView(image: #imageLiteral(resourceName: "tableview_pull_refresh"))
    /// 刷新提示
    lazy var tipLable = UILabel(text: "下拉开始刷新", fontSize: 14, textColor: UIColor.darkGray, textAlignment: .center)
    /// 菊花
    lazy var activityView = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    /// 刷新状态
    var refreshState: JPRefreshState = .Normal {
        
        didSet {
            
            switch refreshState {
            case .Normal:
                //恢复状态
                tipIcon.isHidden = false
                activityView.stopAnimating()
                
                tipLable.text = "下拉开始刷新"
                
                UIView.animate(withDuration: 0.25, animations: {
                    // 恢复矩阵
                    self.tipIcon.transform = CGAffineTransform.identity
                })
                
                break
            case .Pulling:
                tipLable.text = "释放开始刷新"
                /**
                 UIView封装的旋转动画 默认的是顺时针旋转 并且是就近原则
                 想要实现原路径返回 需要调整一个很小的数值
                 如果要360度旋转 使用CABaseAnimation
                 */
                UIView.animate(withDuration: 0.25, animations: {
                    self.tipIcon.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI - 0.001))
                })
                break
            case .WillRefresh:
                tipLable.text = "正在刷新数据"
                tipIcon.isHidden = true
                activityView.startAnimating()
                break
            }
        }
    }
    

}

extension JPRefreshView {

    fileprivate func setupUI() {
        
        backgroundColor = UIColor.clear
        
        addSubview(tipIcon)
        addSubview(tipLable)
        addSubview(activityView)
        
        activityView.hidesWhenStopped = true
        tipIcon.frame = CGRect(x: 0, y: 16, width: 32, height: 32)
        tipLable.frame = CGRect(x: 32, y: 25, width: 100, height: 14)
        activityView.frame = tipIcon.frame
        activityView.activityIndicatorViewStyle = .gray
        
    }
}
