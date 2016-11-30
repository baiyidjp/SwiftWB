//
//  UIImageView+WebImage.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/11/30.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import Foundation

extension UIImageView {
    
    /// 封装SDWebImage
    ///
    /// - Parameters:
    ///   - urlString: 图像URL
    ///   - placeholderImage: 占位图
    ///   - isRound: 是否是圆形
    func jp_setWebImage(urlString: String?,placeholderImage: UIImage?,isRound: Bool = false) {
        
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            
            //设置占位图 然后返回
            image = placeholderImage
            return
        }
        
        /// [weak self] 解决循环引用
        sd_setImage(with: url, placeholderImage: placeholderImage, options: [], progress: nil) { [weak self](image, _, _, _) in
            if isRound  {
                
               self?.image = image?.jp_newRoundImage(size: self?.bounds.size)
            }
        }
    }
}
