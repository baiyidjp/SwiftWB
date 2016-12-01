//
//  JPStatusPictureView.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/11/30.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit

class JPStatusPictureView: UIView {

    /// 配图的高度约束
    @IBOutlet weak var heightCons: NSLayoutConstraint!
    
    override func awakeFromNib() {
        
        setupPicUI()
    }
    
    /// 视图模型
    var statusViewModel: JPStatusViewModel? {
        
        didSet {
            updateViewSize()
        }
    }
    
    fileprivate func updateViewSize() {
        
        //判断是单张图片 只改变第一个view的大小
        if statusViewModel?.picURLs?.count == 1 {
            
            let viewSize = statusViewModel?.pictureViewSize ?? CGSize()
        
            let imageV = subviews[0]
            imageV.frame = CGRect(x: 0, y: JPStatusPicOutterMargin,
                                  width: viewSize.width,
                                  height: viewSize.height - JPStatusPicOutterMargin)
            
        }else{
            //判断是多图(无图) 恢复第一个view的大小
            let imageV = subviews[0]
            imageV.frame = CGRect(x: 0, y: JPStatusPicOutterMargin,
                                  width: JPStatusPictureWidth,
                                  height: JPStatusPictureWidth)
        }
        
        self.heightCons.constant = statusViewModel?.pictureViewSize.height ?? 0
    }
    
    var picUrls: [JPStatusPicModel]? {
        
        didSet {
            //先隐藏所有的图片
            for imageV in subviews {
                imageV.isHidden = true
            }

            let picCount = picUrls?.count ?? 0
            for i in 0..<picCount {
                //取出Model
                let picModel = picUrls?[i]
                //取出子View(4张是例外)
                var imageV = subviews[i] as! UIImageView
                
                if i > 1 && picCount == 4 {
                    
                    imageV = subviews[i+1] as! UIImageView
                }
                //设置图片
                imageV.jp_setWebImage(urlString: picModel?.thumbnail_pic, placeholderImage: nil)
                imageV.isHidden = false
            }
        }
    }
    
}

extension JPStatusPictureView {
    
    fileprivate func setupPicUI() {
        
        backgroundColor = superview?.backgroundColor
        
        //超出边界的内容不显示
        clipsToBounds = true
        //行列总数
        let count = 3
        
        for i in 0..<count*count {
            
            let imageV = UIImageView()
            imageV.backgroundColor = #colorLiteral(red: 1, green: 0.5977384448, blue: 0.6877604723, alpha: 1)
            //设置 content
            imageV.contentMode = .scaleAspectFill
            imageV.clipsToBounds = true
            
            addSubview(imageV)
            //计算行 / 列
            let row = CGFloat(i / count)
            let col = CGFloat(i % count)
            
            //计算x/y
            let imageX = col * (JPStatusPictureWidth + JPStatusPicIntterMargin)
            let imageY = row * (JPStatusPictureWidth + JPStatusPicIntterMargin) + JPStatusPicOutterMargin

            imageV.snp.makeConstraints({ (make) in
                make.top.equalTo(imageY)
                make.left.equalTo(imageX)
                make.size.equalTo(CGSize(width: JPStatusPictureWidth, height: JPStatusPictureWidth))
            })
        }
        
    }
}
