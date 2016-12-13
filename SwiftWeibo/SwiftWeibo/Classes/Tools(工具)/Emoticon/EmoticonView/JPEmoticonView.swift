//
//  JPEmoticonView.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/12/13.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit

/// cellID
fileprivate let cellID = "collectionCell"

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
    
    override func awakeFromNib() {
        
        //注册可重用的cell
//        let nib = UINib(nibName: "JPEmoticonViewCell", bundle: nil)
//        collectionView.register(nib, forCellWithReuseIdentifier: cellID)
        collectionView.register(JPEmoticonViewCell.self, forCellWithReuseIdentifier: cellID)
    }
}

// MARK: - UICollectionViewDelegate,UICollectionViewDataSource
extension JPEmoticonView: UICollectionViewDelegate,UICollectionViewDataSource {
    
    //cell的组
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return JPEmoticonManager.shared.packagesModels.count
    }
    
    //每组的数量
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return JPEmoticonManager.shared.packagesModels[section].numOfPages
    }
    
    //cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! JPEmoticonViewCell
        //设置表情模型数组
        cell.emoticons = JPEmoticonManager.shared.packagesModels[indexPath.section].subEmoticons(page: indexPath.item)
        return cell
    }
}
