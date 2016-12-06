//
//  JPComposeView.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/12/6.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit

class JPComposeView: UIView {

    @IBOutlet weak var scrollView: UIScrollView!
    
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
    }
    
    /// 点击按钮
    @objc fileprivate func clickBtn() {
        print("点了")
    }
    /// 关闭
    @IBAction func closeView() {
        
        removeFromSuperview()
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
    }
    
    func setBtnView(view: UIView,index: Int) {
        
        let count = 6
        
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
            
            //布局
            let btnSize = CGSize(width: 100, height: 100)
            let margin: CGFloat = (ScreenWidth - 3*btnSize.width)/4.0
            let btnTag = i - index
            
            let row = CGFloat(btnTag%3)
            let col = CGFloat(btnTag/3)
            
            let btnX = margin + row*(btnSize.width+margin)
            let btnY = col*(btnSize.height+24)
            
            btn.frame = CGRect(x: btnX, y: btnY, width: btnSize.width, height: btnSize.height)
            view.addSubview(btn)
            btn.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)
        }
    }
    
}
