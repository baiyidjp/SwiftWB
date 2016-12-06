//
//  JPRefreshJDView.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/12/6.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit

let viewNormalHeight: CGFloat = 84
let personImageCenterX: CGFloat = 100


class JPRefreshJDView: UIView {

    /// 图片
    lazy var tipBoxIcon = UIImageView(image: #imageLiteral(resourceName: "box"))
    /// 小人
    lazy var tipPersonIcon = UIImageView(image: #imageLiteral(resourceName: "staticDeliveryStaff"))
    /// 刷新提示
    lazy var tipLable = UILabel(text: "下拉更新...", fontSize: 14, textColor: UIColor.darkGray, textAlignment: .left)
    /// label
    lazy var staticLable = UILabel(text: "让购物更健康", fontSize: 14, textColor: UIColor.darkGray, textAlignment: .left)
    /// 刷新图片
    lazy var refreshImage = UIImageView(image: #imageLiteral(resourceName: "deliveryStaff"))
    
    //高度
    var viewHeight: CGFloat = 0 {
        
        didSet {

            if viewHeight > viewNormalHeight {
                refreshImage.isHidden = false
                tipPersonIcon.isHidden = true
                tipBoxIcon.isHidden = true
            }else{
                refreshImage.isHidden = true
                tipPersonIcon.isHidden = false
                tipBoxIcon.isHidden = false
                tipPersonIcon.transform = CGAffineTransform(scaleX: viewHeight/viewNormalHeight, y: viewHeight/viewNormalHeight)
                tipBoxIcon.transform = CGAffineTransform(scaleX: viewHeight/viewNormalHeight, y: viewHeight/viewNormalHeight)
                if refreshState == .WillRefresh {
                    refreshImage.isHidden = false
                    tipPersonIcon.isHidden = true
                    tipBoxIcon.isHidden = true
                }
            }
        }
    }
    
    
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
                tipLable.text = "下拉更新..."
                break
            case .Pulling:
                tipLable.text = "松手更新..."
                break
            case .WillRefresh:
                tipLable.text = "更新中..."
                break
            }
        }
    }


}

extension JPRefreshJDView {
    
    fileprivate func setupUI() {
        
        backgroundColor = UIColor.clear
        
        addSubview(tipPersonIcon)
        addSubview(tipBoxIcon)
        addSubview(tipLable)
        addSubview(staticLable)
        addSubview(refreshImage)
        
        tipPersonIcon.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        tipPersonIcon.center = CGPoint(x: personImageCenterX, y: viewNormalHeight)
        tipPersonIcon.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        tipBoxIcon.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        tipBoxIcon.center = CGPoint(x: tipPersonIcon.frame.maxX+20, y: viewNormalHeight-tipPersonIcon.bounds.height/2)
        
        refreshImage.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        refreshImage.center = CGPoint(x: personImageCenterX, y: viewNormalHeight)
        refreshImage.isHidden = true
        let imageA = #imageLiteral(resourceName: "deliveryStaff1")
        let imageB = #imageLiteral(resourceName: "deliveryStaff2")
        let imageC = #imageLiteral(resourceName: "deliveryStaff3")
        refreshImage.image = UIImage.animatedImage(with: [imageA,imageB,imageC], duration: 0.3)
        
        staticLable.frame = CGRect(x: tipBoxIcon.frame.maxX+30, y: 27, width: 90, height: 14)
        tipLable.frame = CGRect(x: tipBoxIcon.frame.maxX+30, y: 51, width: 90, height: 14)
    }
}
