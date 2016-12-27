//
//  JPPhotoBrowserAnimator.swift
//  SwiftWeibo
//
//  Created by Keep丶Dream on 16/12/27.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit

/// 负责转场动画的细节  
/// UIViewControllerTransitioningDelegate 控制器自定义转场的代理
class JPPhotoBrowserAnimator: NSObject,UIViewControllerTransitioningDelegate {
    
    fileprivate var isPresend = false
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresend = true
        
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresend = false
        
        return self
    }
}

// MARK: - UIViewControllerAnimatedTransitioning
// 负责转场动画的具体实现 功能和逻辑
extension JPPhotoBrowserAnimator: UIViewControllerAnimatedTransitioning {
    
    /// 转场动画时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    /// 指定具体的动画逻辑--一旦实现了当前方法 系统默认的转场动画失效 所有动画需要程序员自己提供
    ///
    /// - Parameter transitionContext: 转场上下文 提供转场所需相关内容
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
    }
}
