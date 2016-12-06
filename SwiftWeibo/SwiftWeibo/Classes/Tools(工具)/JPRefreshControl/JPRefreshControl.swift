//
//  JPRefreshControl.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/12/5.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit

let refreshViewW: CGFloat = ScreenWidth
let refreshViewH: CGFloat = 84
let refreshOffset: CGFloat = 84
/// 刷新状态枚举
///
/// - Normal: 普通状态
/// - Pulling: 超过临界点 放手将会刷新
/// - WillRefresh: 超过临界点 并且一放手
enum JPRefreshState {
    case Normal
    case Pulling
    case WillRefresh
}

class JPRefreshControl: UIControl {
    
    /// 懒加载 滚动视图
    fileprivate weak var scrollView: UIScrollView?
    /// 刷新视图
    fileprivate lazy var refreshView = JPRefreshJDView(frame: CGRect())
    
    /// 构造函数
    init() {
        
        super.init(frame: CGRect())
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
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
    
    /// 移除KVO监听
    override func removeFromSuperview() {
        
        //superView还存在
        superview?.removeObserver(self, forKeyPath: "contentOffset")
        super.removeFromSuperview()
        //superView已移除
    }
    
    /// 所有的KVO都会调用这个方法
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        /// 有contentOffset的Y值 + contentInset.top的值 便是刷新控件的高度
        guard let scrollV = scrollView else {
            return
        }
        
        var height = -(scrollV.contentOffset.y + scrollV.contentInset.top)
        
        //对于个别height<0的情况处理
        if height < 0 {
            height = 0
        }
        //刷新View的高度 用来设置动画
        refreshView.viewHeight = height
        /// 设置刷新控件的frame
        self.frame = CGRect(x: 0, y: -height, width: scrollV.bounds.width, height: height)
        self.refreshView.frame = CGRect(x: 0, y: height-refreshViewH, width: refreshViewW, height: refreshViewH)
        /// 临界点
        if scrollV.isDragging {
            
            if height > refreshOffset && (refreshView.refreshState == .Normal) {
                refreshView.refreshState = .Pulling
                
            }else if height <= refreshOffset && (refreshView.refreshState == .Pulling) {
                refreshView.refreshState = .Normal
                
            }
            
        }else{
            
            // 放手 -- 判断是否超过临界点
            if refreshView.refreshState == .Pulling {
                //开始刷新
                beginRefreshing()
                //发送刷新数据的事件
                sendActions(for: .valueChanged)
                // 刷新结束后 将状态改为Normal 才能继续刷新
            }
        }
    }
    
    /// 开始刷新
    func beginRefreshing() {
        
        guard let scrollV = scrollView else {
            return
        }
        //判断是否正在刷新 正在刷新则返回
        if refreshView.refreshState == .WillRefresh {
            return
        }
        //设置刷新视图的状态
        refreshView.refreshState = .WillRefresh
        //让刷新控件界面显示出来  修改滚动视图的 contentInset
        var inset = scrollV.contentInset
        inset.top += refreshOffset
        scrollView?.contentInset = inset
        print("inset-- \(scrollView?.contentInset)")
    }
    
    /// 结束刷新
    func endRefreshing() {
        guard let scrollV = scrollView else {
            return
        }
        //判断是否正在刷新 正在刷新则返回
        if refreshView.refreshState != .WillRefresh {
            return
        }
        //恢复刷新视图的状态
        refreshView.refreshState = .Normal
        //恢复表格的contentInset
        var inset = scrollV.contentInset
        inset.top -= refreshOffset
        scrollView?.contentInset = inset
    }
}

extension JPRefreshControl {
    
    fileprivate func setupUI() {
        
        backgroundColor = superview?.backgroundColor

        addSubview(refreshView)
    }
}
