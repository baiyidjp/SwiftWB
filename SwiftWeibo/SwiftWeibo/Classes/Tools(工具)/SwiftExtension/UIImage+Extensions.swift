//
//  UIImage+Extensions.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/11/29.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import Foundation

extension UIImage {
    
    func jp_newRoundImage(size: CGSize?,backColor: UIColor = UIColor.white,lineColor: UIColor = UIColor.lightGray) -> UIImage? {
        
        var imageSize = size
        if imageSize == nil {
            imageSize = self.size
        }
        let rect = CGRect(origin: CGPoint(), size: imageSize!)
        
        //取出上下文
        //size 需要绘制的区域
        //opaque 是否透明 true--不透明
        //scale 分辨率  0--默认为当前设备的分辨率
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        //背景颜色填充
        backColor.setFill()
        UIRectFill(rect)
        //裁剪上下文--裁剪出一个圆形的上下文
        let path =  UIBezierPath(ovalIn: rect)
        path.addClip()
        //重新将图片绘制到上下文中 --防止拉伸压缩原始图片
        draw(in: rect)
        //绘制圆形边界--颜色
        lineColor.setStroke()
        path.lineWidth = 1
        path.stroke()
        //取出图片
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭上下文
        UIGraphicsEndImageContext()
        //返回
        return resultImage
    }
}
