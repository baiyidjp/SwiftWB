//
//  JPComposeView.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/12/6.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit
import pop

class JPComposeView: UIView {

    @IBOutlet weak var scrollView: UIScrollView!
    /// 返回按钮
    @IBOutlet weak var returnBtn: UIButton!
    /// 中间的细线
    @IBOutlet weak var lineView: UIView!
    /// 关闭按钮的centerX
    @IBOutlet weak var closeBtnCenterXCons: NSLayoutConstraint!
    /// 返回按钮的centerX
    @IBOutlet weak var returnBtnCenterXCons: NSLayoutConstraint!
    /// btn容器
    lazy var buttonArray = [JPComposeBtn]()
    
    let buttonInfo = [["imageName":"tabbar_compose_idea","title":"文字"],
                      ["imageName":"tabbar_compose_photo","title":"照片/视频"],
                      ["imageName":"tabbar_compose_headlines","title":"头条文章"],
                      ["imageName":"tabbar_compose_lbs","title":"签到"],
                      ["imageName":"tabbar_compose_video","title":"直播"],
                      ["imageName":"tabbar_compose_more","title":"更多"],
                      ["imageName":"tabbar_compose_review","title":"点评"],
                      ["imageName":"tabbar_compose_friend","title":"好友圈"],
                      ["imageName":"tabbar_compose_music","title":"音乐"],
                      ["imageName":"tabbar_compose_shooting","title":"秒拍"],
                      ["imageName":"tabbar_compose_envelope","title":"红包"],
                      ["imageName":"tabbar_compose_productrelease","title":"商品"]]
    
    
    class func composeView() -> JPComposeView {
        
        let nib = UINib(nibName: "JPComposeView", bundle: nil)
        // 从XIB加载完视图就会调用 awakeFromNib 如果在 awakeFromNib 中调用 setupUI() 由于frame还未设置 则无法更新布局
        let view = nib.instantiate(withOwner: nil, options: nil)[0] as! JPComposeView
        
        view.frame = UIScreen.main.bounds
        view.setupUI()
        
        return view
        
    }
    
    func showView() {
        
        guard let mainVC = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        
        mainVC.view.addSubview(self)
        
        //动画
        showCurrentView()
    }
    
    /// 点击按钮
    @objc fileprivate func clickBtn(btn: JPComposeBtn) {
        print("点了\(btn.tag)")
        if btn.tag == 5 {
            
            // 滚动视图 需要动画的使用 set 方法 .方法不带动画属性
            scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width, y: 0), animated: true)
            // 显示
            returnBtn.isHidden = false
            lineView.isHidden = false
            // 改变中心
            let margin = scrollView.bounds.width / 4
            
            closeBtnCenterXCons.constant += margin
            returnBtnCenterXCons.constant -= margin
            
            UIView.animate(withDuration: 0.3) {
            
                self.layoutIfNeeded()
            }
            // 如果点击是更多按钮 则不做动画
            return
        }
        
        clickAnimation(btn: btn)
    }
    /// 关闭
    @IBAction func closeView() {
        
        showCloseAnimation()
    }
    /// 返回按钮的点击
    @IBAction func returnBtnClick() {
        // 滚动视图
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        // 显示
        returnBtn.isHidden = true
        lineView.isHidden = true
        // 改变中心
        let margin = scrollView.bounds.width / 4
        
        closeBtnCenterXCons.constant -= margin
        returnBtnCenterXCons.constant += margin
        
        UIView.animate(withDuration: 0.3) {
            
            self.layoutIfNeeded()
        }

    }
}
/// extension前加 fileprivate 表明extension中所有的方法都是加密的
fileprivate extension JPComposeView {
    
    func setupUI() {
        // 强行更新布局
        layoutIfNeeded()
        
        for i in 0..<2 {
            
            let view = UIView(frame: CGRect(x: CGFloat(i)*scrollView.bounds.width, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height))
            
            setBtnView(view: view, index: i*6)
            
            scrollView.addSubview(view)
        }
        
        scrollView.contentSize = CGSize(width: 2*scrollView.bounds.width, height: 0)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.isScrollEnabled = false
    }
    
    func setBtnView(view: UIView,index: Int) {
        
        let count = 6
        let btnBeginY = ScreenHeight - scrollView.frame.minY
        
        for i in index..<index+count {
            
            // 直接跳出循环
            if i >= buttonInfo.count {
                break
            }
            
            // 取出对应的按钮的信息
            let dict = buttonInfo[i]
            
            //结束当前循环 开始下一个
            guard let imageName = dict["imageName"],
                  let title = dict["title"]  else {
                continue
            }
            let btn = JPComposeBtn.composebtn(imageName: imageName, title: title)
            btn.tag = i
            //将按钮加到 按钮的容器中
            buttonArray.append(btn)
            //布局
            let btnSize = CGSize(width: 100, height: 100)
            let margin: CGFloat = (ScreenWidth - 3*btnSize.width)/4.0
            let btnTag = i - index
            
            let row = CGFloat(btnTag%3)
            let col = CGFloat(btnTag/3)
            
            let btnX = margin + row*(btnSize.width+margin)
            let btnY = col*(btnSize.height+24) + btnBeginY
            
            btn.frame = CGRect(x: btnX, y: btnY, width: btnSize.width, height: btnSize.height)
            view.addSubview(btn)
            btn.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)
        }
    }
    
}

// MARK: - 动画扩展
fileprivate extension JPComposeView {
    
    func showCurrentView() {
       
        let btnBeginY = ScreenHeight - scrollView.frame.minY
        
        for (i,composeBtn) in buttonArray.enumerated() {
            
            //1--渐变动画
            let alphaAnima: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            alphaAnima.fromValue = 0
            alphaAnima.toValue = 1
            alphaAnima.duration = 0.3
            composeBtn.pop_add(alphaAnima, forKey: nil)
            //2-弹性动画
            let springAnima: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            //改变
            springAnima.toValue = composeBtn.center.y - btnBeginY
            //弹力系数 取值0-20 数值越大 弹性越大 默认4
            springAnima.springBounciness = 8
            //弹力速速 取值0-20 数值越大 速度越快 默认12
            springAnima.springSpeed = 8
            //动画开启时间
            springAnima.beginTime = CACurrentMediaTime() + CFTimeInterval(i) * 0.025
            //添加
            composeBtn.pop_add(springAnima, forKey: nil)
        }
    }
    
    func showCloseAnimation() {
        
        let btnBeginY = ScreenHeight - scrollView.frame.minY
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        let view = scrollView.subviews[page]
        
        for (i,composeBtn) in view.subviews.enumerated().reversed() {
            print(i)
            //1--渐变动画
            let alphaAnima: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            alphaAnima.fromValue = 1
            alphaAnima.toValue = 0
            alphaAnima.duration = 0.3
            composeBtn.pop_add(alphaAnima, forKey: nil)
            //2-弹性动画
            let springAnima: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            //改变
            springAnima.toValue = composeBtn.center.y + btnBeginY
            //弹力系数 取值0-20 数值越大 弹性越大 默认4
            springAnima.springBounciness = 8
            //弹力速速 取值0-20 数值越大 速度越快 默认12
            springAnima.springSpeed = 8
            //动画开启时间
            springAnima.beginTime = CACurrentMediaTime() + CFTimeInterval(view.subviews.count-1-i) * 0.025
            //添加
            composeBtn.pop_add(springAnima, forKey: nil)
            
            if i == 0 {
                springAnima.completionBlock = {_,_ in
                    
                    self.removeFromSuperview()
                }
            }
        }

    }
    
    func clickAnimation(btn: JPComposeBtn) {
        
        for composeBtn in buttonArray {
            
            //1--缩放动画
            let scaleAnima: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewScaleXY)
            
            //是否是当前点击的按钮
            let scale = (composeBtn == btn) ? 2 : 0.2
            
            //用Value包装x.y
            scaleAnima.toValue = NSValue(cgPoint: CGPoint(x: scale, y: scale))
            scaleAnima.duration = 0.5
            
            //将动画加到btn上
            composeBtn.pop_add(scaleAnima, forKey: nil)
            
            //2--渐变动画
            let alphaAnima: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            alphaAnima.toValue = 0.2
            alphaAnima.duration = 0.5
            composeBtn.pop_add(alphaAnima, forKey: nil)
            
            if composeBtn == buttonArray[0] {
                alphaAnima.completionBlock = {_,_ in
                    print("动画完成")
                }
            }
        }

    }
}
