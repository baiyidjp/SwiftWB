//
//  JPNavigationController.swift
//  SwiftWeibo
//
//  Created by Keep丶Dream on 16/11/19.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit

class JPNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //隐藏系统 navigationBar
        navigationBar.isHidden = true
    }
    
    
    /// 重写push方法  所有的push动作都会调用此方法
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if childViewControllers.count > 0 {
            
            //隐藏底部的tabBar
            viewController.hidesBottomBarWhenPushed = true
            
            //设置返回的按钮
            if let vc = viewController as? JPBaseViewController {
                
                var backTitle = "返回"
                
                if childViewControllers.count == 1 {
                    
                    backTitle = childViewControllers.first?.title ?? "返回"
                }
                
                let backItem = UIBarButtonItem(title: backTitle, target: self, action: #selector(popBack),isBackButton: true)
                //为了向左缩进
                let spaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
                spaceItem.width = -10
                vc.JPNavigationItem.leftBarButtonItems = [spaceItem,backItem]
                
                
            }
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc fileprivate func popBack() {
        
        popViewController(animated: true)
    }
    
}
