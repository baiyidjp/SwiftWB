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
            //正常显示图片  (有转发的时候使用转发)
            picUrls = statusViewModel?.picURLs
            
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
                
                //设置gif显示与否 lowercased-小写
                let gifView = imageV.subviews[0]
                gifView.isHidden = (((picModel?.thumbnail_pic ?? "") as NSString).pathExtension.lowercased() != "gif")
            }
        }
    }
    
    @objc fileprivate func tapImageView(gesture:UITapGestureRecognizer) {
        
        //获取对应的tag值
        var index = gesture.view!.tag;
        //针对四张图片单独处理
        if index > 2 && picUrls?.count == 4 {
            index -= 1
        }
        //从picUrls中 获得 thumbnail_pic 的字符串数组
        guard let picUrls = picUrls else {
            return
        }
        //使用KVC获取字符串数组
        let urlStrs = (picUrls as NSArray).value(forKey: "thumbnail_pic")
        
        //发送通知 传输数据 将当前点击的图片的下标还有URL数组传递给HomeController
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: JPStatusPicturesSelectedNotification),
                                        object: self,
                                        userInfo: [JPStatusPicturesSelectedIndexKey:index,
                                                   JPStatusPicturesSelectedUrlsKey:urlStrs])
        
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
            
            imageV.frame = CGRect(x: imageX, y: imageY, width: JPStatusPictureWidth, height: JPStatusPictureWidth)
            //添加手势
            imageV.tag = i;
            imageV.isUserInteractionEnabled = true;
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapImageView))
            imageV.addGestureRecognizer(tap);
            
            addGifView(imageV: imageV)
        }
        
    }
    
    func addGifView(imageV: UIImageView) {
        
        let gifView = UIImageView(image: #imageLiteral(resourceName: "timeline_image_gif"))
        imageV.addSubview(gifView)
        //自动布局
        gifView.snp.makeConstraints { (make) in
            make.right.equalTo(imageV)
            make.bottom.equalTo(imageV)
        }
    }
}
