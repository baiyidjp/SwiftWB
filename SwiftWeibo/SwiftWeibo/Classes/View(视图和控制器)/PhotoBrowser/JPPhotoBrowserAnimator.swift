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
    
    /// 是否是展示
    fileprivate var isPresent = false
    
    /// 展示临时视图的位置/图片来源 用于动画
    var presentingImageView: UIImageView? {
        
        didSet {
            self.currentImageView = presentingImageView
        }
    }
    
    var currentImageView: UIImageView?
    
    
    override init() {
        
        super.init()
    }
    
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
        
        //拿到系统提供的容器视图
        let containerView = transitionContext.containerView
        
        //新建临时的展示视图 用于动画
        let imageView = UIImageView()
        guard let image = currentImageView?.image else {
            return
        }
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        guard let frame = currentImageView?.frame else {
            return
        }
        
        //拿到presentingImageView父视图上的presentingImageView 在containerView 上的frame
        imageView.frame = containerView.convert(frame, from: currentImageView?.superview)
        //添加临时的imageView
        containerView.addSubview(imageView)
        //计算目的frame
        let toRect = setImageSize(image: image)
        
        //将目标视图添加到容器视图
        containerView.addSubview(toView!)
        
        //简单的动画
        toView?.alpha = 0
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       animations: {
                        //设置变大
                        imageView.frame = toRect
        }) { (_) in
            //删除临时view
            imageView.removeFromSuperview()
            //设置目标视图显示
            toView?.alpha = 1
            //告诉上下文转转场动画结束  结束之前 默认没有交互
            transitionContext.completeTransition(true)
        }
    }
    /// 解除动画  从 browser 回到 Home
    private func dismissTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        //拿到照片浏览的视图 是from
        let fromView = transitionContext.view(forKey: .from)
        
        //拿到系统提供的容器视图
        let containerView = transitionContext.containerView
        
        //新建临时的展示视图 用于动画
        let imageView = UIImageView()
        
        guard let image = currentImageView?.image else {
            return
        }
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        //计算目的frame
        imageView.frame = setImageSize(image: image)
        
        guard let frame = currentImageView?.frame else {
            return
        }
        
        //拿到presentingImageView父视图上的presentingImageView 在containerView 上的frame
        let toRect = containerView.convert(frame, from: currentImageView?.superview)
        //添加临时的imageView
        containerView.addSubview(imageView)

        
        //简单的动画
        fromView?.alpha = 0
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       animations: {
                        imageView.frame = toRect
        }) { (_) in
            
            //移除
            fromView?.removeFromSuperview()
            imageView.removeFromSuperview()
            //结束转场
            transitionContext.completeTransition(true)
        }
        
    }
    
    /// 根据图片设置 imageView的尺寸
    ///
    /// - Parameter image:
    fileprivate func setImageSize(image: UIImage)-> CGRect {
        
        let screenSize = UIScreen.main.bounds.size
        var size = screenSize
        // 根据屏幕的宽度计算图片的高度
        size.height = image.size.height * size.width / image.size.width
        //创建一个CGRect
        var rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        //设置短图居中显示
        if size.height < screenSize.height {
            rect.origin.y = (screenSize.height - size.height)*0.5
        }
        
        return rect
    }


}
