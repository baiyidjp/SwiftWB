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
        
        let btn = JPComposeBtn.composebtn(imageName: "tabbar_compose_weibo", title: "文字")
        btn.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        addSubview(btn)
        
        btn.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)
    }
}
