//
//  JPEmoticonView.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/12/13.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit

class JPEmoticonView: UIView {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var toolView: UIView!
    /// 从XIB加载shi'tu
    ///
    /// - Returns: 返回视图
    class func emoticonView() -> JPEmoticonView {
        
        let nib = UINib(nibName: "JPEmoticonView", bundle: nil)
        
        let view = nib.instantiate(withOwner: nil, options: nil)[0] as! JPEmoticonView
        
        return view
        
    }

}
