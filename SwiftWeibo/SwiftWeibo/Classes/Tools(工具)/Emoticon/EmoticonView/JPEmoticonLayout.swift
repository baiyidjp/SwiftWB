//
//  JPEmoticonLayout.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/12/13.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit

class JPEmoticonLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        
        //collection的滑动方向和排列方向相反
        
        //size
        guard let collectionView = collectionView else {
            return
        }
        
        itemSize = collectionView.bounds.size
    }
}
