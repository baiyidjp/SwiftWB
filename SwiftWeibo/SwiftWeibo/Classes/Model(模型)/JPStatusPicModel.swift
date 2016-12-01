//
//  JPStatusPicModel.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/11/30.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit

class JPStatusPicModel: NSObject {
    
    /// 单张图片的缩略图地址
    var thumbnail_pic: String?
    /// 单张图片的大图地址
    var imageOrignalUrl: String? {
        
        let url = thumbnail_pic?.replacingOccurrences(of: "thumbnail", with: "or360")
        return url
    }
    
}
