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
    
    //闭包属性 点击表情
    fileprivate var seletedEmoticonCallBack: ((_ emoticonModel:JPEmoticonModel?)->())?
    
    /// 从XIB加载shi'tu
    ///
    /// - Returns: 返回视图
    class func emoticonView(seletedEmoticon:@escaping (_ emoticonModel:JPEmoticonModel?)->()) -> JPEmoticonView {
        
        let nib = UINib(nibName: "JPEmoticonView", bundle: nil)
        
        let view = nib.instantiate(withOwner: nil, options: nil)[0] as! JPEmoticonView
        
        //记录闭包
        view.seletedEmoticonCallBack =  seletedEmoticon
        
        return view
        
    }
    
    override func awakeFromNib() {
        
        //注册可重用的cell
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
        cell.delegate = self
        return cell
    }
}

// MARK: - JPEmoticonViewCellDelegate
extension JPEmoticonView: JPEmoticonViewCellDelegate {
    
    func emoticonViewCellSelectEmoticon(cell: JPEmoticonViewCell, emoticonModel: JPEmoticonModel?) {
//        print(emoticonModel)
        // 点击表情
        seletedEmoticonCallBack?(emoticonModel)
        //添加最近表情
        guard let emoticonModel = emoticonModel else {
            return
        }
        JPEmoticonManager.shared.addLastEmoticon(emoticonModel: emoticonModel)
    }
}
