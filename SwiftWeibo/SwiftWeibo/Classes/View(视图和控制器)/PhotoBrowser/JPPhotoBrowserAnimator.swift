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
    
    fileprivate var isPresent = false
    
    /// 返回真正的 present 动画
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresent = true
        
        return self
    }
    
    /// 返回真正的 dismiss 动画
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresent = false
        
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
        
        isPresent ? presentTransition(using: transitionContext): dismissTransition(using: transitionContext)
    }
    /*
     转场动画需要的内容 从'from控制器' 到 'to控制器'
     1-位置
     2-方式
     3-容器视图 存放被展现视图控制器的视图->动画代码实现的舞台
     */
    //MARK: -动画函数
    /// 展现动画
    private func presentTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        //目标视图
        let toView = transitionContext.view(forKey: .to)
        let toVC = transitionContext.viewController(forKey: .to)
        
        //拿到系统提供的容器视图
        let containerView = transitionContext.containerView
        //将目标视图添加到容器视图
        containerView.addSubview(toView!)
        //告诉上下文转转场动画结束  结束之前 默认没有交互
        transitionContext.completeTransition(true)
        
        
    }
    /// 解除动画  从 browser 回到 Home
    private func dismissTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        //拿到照片浏览的视图 是from
        let fromView = transitionContext.view(forKey: .from)
        //移除
        fromView?.removeFromSuperview()
        //结束转场
        transitionContext.completeTransition(true)
        
    }

}
