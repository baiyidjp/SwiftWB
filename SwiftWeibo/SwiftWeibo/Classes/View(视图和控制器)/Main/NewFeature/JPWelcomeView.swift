//
//  JPWelcomeView.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/11/28.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit
import SDWebImage

class JPWelcomeView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -懒加载view
    /// 底部视图
    fileprivate lazy var adBackgroundImage: UIImageView = UIImageView(image: UIImage(named:"ad_background"))
    /// 头像
    fileprivate lazy var avatarImage: UIImageView = UIImageView()
    /// 欢迎文字
    fileprivate lazy var welcomeLable: UILabel = UILabel(text: "欢迎归来", fontSize: 16, textColor: UIColor.purple, textAlignment: .center)
    
    /// view显示在window上 已经显示在视图上
    override func didMoveToWindow() {
        
        self.layoutIfNeeded()
        avatarImage.snp.updateConstraints { (make) in
            make.bottom.equalTo(200-bounds.size.height)
        }
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {
                        self.layoutIfNeeded()
        }) { (_) in
            
            UIView.animate(withDuration: 1.0, animations: { 
                self.welcomeLable.alpha = 1.0
            }, completion: { (_) in
                self.removeFromSuperview()
            })
        }
    }
}

// MARK: - add views
extension JPWelcomeView {
    
    fileprivate func setUpViews() {
        
        addSubview(adBackgroundImage)
        addSubview(avatarImage)
        addSubview(welcomeLable)
        
        welcomeLable.alpha = 0

        avatarImage.jp_setWebImage(urlString: JPNetworkManager.sharedManager.userAccount.avatar_large, placeholderImage: #imageLiteral(resourceName: "avatar_default_big"), isRound: true,backColor: UIColor(patternImage: #imageLiteral(resourceName: "ad_background")))
        
        setViewConstraints()
    }
    
    fileprivate func setViewConstraints() {
        
        adBackgroundImage.snp.makeConstraints { (make) in
            make.left.top.bottom.right.equalTo(0)
        }
        
        avatarImage.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(-160)
            make.width.equalTo(CGSize(width: 85, height: 85))
        }
        
        welcomeLable.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(avatarImage.snp.bottom).offset(15)
        }
    }
}
