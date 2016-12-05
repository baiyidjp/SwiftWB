//
//  JPRefreshControl.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/12/5.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit

class JPRefreshControl: UIControl {
    
    /// 懒加载 滚动视图
    fileprivate weak var scrollView: UIScrollView?
    
    /// 构造函数
    init() {
        
        super.init(frame: CGRect())
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    /// 开始刷新
    func beginRefreshing() {
        
    }
    
    /// 结束刷新
    func endRefreshing() {
    
    }
    
    /// 将要显示在父视图上
    ///
    /// - Parameter newSuperview: 父视图
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        //记录父视图
        guard let superView = newSuperview as? UIScrollView else {
            //如果父视图不是滚动视图 则直接返回
            return
        }
        
        scrollView = superView
        
        /// KVO添加监听父视图的 contentOffest
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
    }
    
    /// 所有的KVO都会调用这个方法
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        /// 有contentOffset的Y值 + contentInset.top的值 便是刷新控件的高度
        guard let scrollV = scrollView else {
            return
        }
        
        let height = -(scrollV.contentOffset.y + scrollV.contentInset.top)
        
        /// 设置刷新控件的frame
        self.frame = CGRect(x: 0, y: -height, width: scrollV.bounds.width, height: height)
        
    }

}

extension JPRefreshControl {
    
    fileprivate func setupUI() {
        
        backgroundColor = UIColor.purple
    }
}
