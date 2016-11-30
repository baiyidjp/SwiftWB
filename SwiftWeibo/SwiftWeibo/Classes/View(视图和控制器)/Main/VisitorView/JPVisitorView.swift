//
//  JPVisitorView.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/11/21.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit

class JPVisitorView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: 访客信息字典 模仿OC的setter
    // dict : imageName/tipTitle 
    // 如果是首页 imageName = ""
    var visitorInfo: [String: String]? {
        didSet{
            guard let imageName = visitorInfo?["imageName"],
                let tipTitle = visitorInfo?["tipTitle"]
                else {
                    return
            }
            
            tipLable.text = tipTitle
            //是首页 不在重新设置 直接返回
            if imageName == "" {
                //启动动画
                startAnimation()
                return
            }
            iconView.image = UIImage(named: imageName)
            //其他视图不需要小房子视图 和 遮罩视图
            houseIconView.isHidden = true
            maskIconView.isHidden = true
        }
    }
    
    //MARK: 旋转
    fileprivate func startAnimation() {
        
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = 2 * M_PI
        animation.repeatCount = MAXFLOAT
        animation.duration = 15
        //动画完成之后不删除
        animation.isRemovedOnCompletion = false
        
        //添加到图层
        iconView.layer.add(animation, forKey: nil)
    }
    
    //MARK: 控件
    //图像视图
    fileprivate lazy var iconView: UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
    //底部遮罩视图
    fileprivate lazy var maskIconView: UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
    //小房子
    fileprivate lazy var houseIconView: UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
    //提示
    fileprivate lazy var tipLable: UILabel = UILabel(text: "关注一些人,回到这里看看有什么惊喜 ! ! !关注一些人,回到这里看看有什么惊喜 ! ! !",
                                         fontSize: 15,
                                         textColor: UIColor.darkGray)
    //注册按钮
    lazy var registerButton: UIButton = UIButton(title: "注册",
                                                 fontSize: 16,
                                                 normalColor: UIColor.orange,
                                                 highlightColor: UIColor.darkGray,
                                                 backgroundImageName: "common_button_white_disable")
    //登录按钮
    lazy var loginButton: UIButton = UIButton(title: "登录",
                                                 fontSize: 16,
                                                 normalColor: UIColor.darkGray,
                                                 highlightColor: UIColor.darkGray,
                                                 backgroundImageName: "common_button_white_disable")
}

//MARK: 设置界面
extension JPVisitorView {
    
    fileprivate func setupUI() {
        
        backgroundColor = UIColor.hm_color(withHex: 0xEDEDED)
        
        //添加视图
        addSubview(iconView)
        addSubview(maskIconView)
        addSubview(houseIconView)
        addSubview(tipLable)
        addSubview(registerButton)
        addSubview(loginButton)
        
        setViewConstraints()
    }
    
    fileprivate func setViewConstraints() {
        
        iconView.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-60)
        }

        /// 原生API自动布局
//        addConstraint(NSLayoutConstraint(item: houseIconView,
//                                         attribute: .centerX,
//                                         relatedBy: .equal,
//                                         toItem: iconView,
//                                         attribute: .centerX,
//                                         multiplier: 1.0,
//                                         constant: 0))
//        addConstraint(NSLayoutConstraint(item: houseIconView,
//                                         attribute: .centerY,
//                                         relatedBy: .equal,
//                                         toItem: iconView,
//                                         attribute: .centerY,
//                                         multiplier: 1.0,
//                                         constant: 0))
        houseIconView.snp.makeConstraints { (make) in
            make.centerX.equalTo(iconView.snp.centerX)
            make.centerY.equalTo(iconView.snp.centerY)
        }
        
        tipLable.numberOfLines = 0
        tipLable.snp.makeConstraints { (make) in
            make.centerX.equalTo(iconView.snp.centerX)
            make.top.equalTo(iconView.snp.bottom).offset(10)
            make.width.equalTo(self.bounds.width-100)
        }
        
        registerButton.snp.makeConstraints { (make) in
            make.left.equalTo(tipLable.snp.left)
            make.top.equalTo(tipLable.snp.bottom).offset(10)
            make.width.equalTo(tipLable.snp.width).multipliedBy(0.3)
        }
        
        loginButton.snp.makeConstraints { (make) in
            make.right.equalTo(tipLable.snp.right)
            make.top.equalTo(tipLable.snp.bottom).offset(10)
            make.width.equalTo(tipLable.snp.width).multipliedBy(0.3)
        }
        
        maskIconView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.bottom.equalTo(registerButton.snp.top)
        }
    }
}
