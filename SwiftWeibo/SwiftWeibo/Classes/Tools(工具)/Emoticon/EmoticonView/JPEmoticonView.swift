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
    @IBOutlet weak var toolView: JPEmoticonToolView!
    @IBOutlet weak var pageControl: UIPageControl!
    
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
        
        //设置底部工具栏的代理
        toolView.delegate = self
    }
}

// MARK: - JPEmoticonToolViewDelegate
extension JPEmoticonView: JPEmoticonToolViewDelegate {
    
    func emoticonToolBarItemDidSelectIndex(toolView: JPEmoticonToolView, index: Int) {
        
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //获取中心店
        var center = scrollView.center
        center.x += scrollView.contentOffset.x
        
        //获取当前显示的 cell 的indexPath集合
        let paths = collectionView.indexPathsForVisibleItems
        
        var currentIndex: IndexPath?
        //判断中心点在哪一个cell内
        for indexPath in paths {
            
            //根据indexpath获取当前的cell
            let cell = collectionView.cellForItem(at: indexPath)
            
            //判断中心点位置
            if cell?.frame.contains(center) == true {
                currentIndex = indexPath
                break
            }
        }
        
        guard let indexPath = currentIndex else {
            return
        }
        toolView.selectIndex = indexPath.section
        
        //设置分页控件
        pageControl.numberOfPages = collectionView.numberOfItems(inSection: indexPath.section)
        pageControl.currentPage = indexPath.item
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
        //如果是最近分组 就不添加最近使用表情
        let indexPath = collectionView.indexPathsForVisibleItems[0]
        if indexPath.section == 0 {
            return
        }
        JPEmoticonManager.shared.addLastEmoticon(emoticonModel: emoticonModel)
        
        //刷新最近组的数据
        var indexSet = IndexSet()
        indexSet.insert(0)
        collectionView.reloadSections(indexSet)
    }
}
