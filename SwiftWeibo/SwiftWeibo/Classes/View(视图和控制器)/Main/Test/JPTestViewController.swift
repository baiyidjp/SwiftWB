//
//  JPTestViewController.swift
//  SwiftWeibo
//
//  Created by Keep丶Dream on 16/11/19.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit

class JPTestViewController: JPBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "第 \(navigationController?.childViewControllers.count ?? 0) 个"
    }

    func showNext() {
        
        let testVC = JPTestViewController()
        
        navigationController?.pushViewController(testVC, animated: true)
    }
}


//MARK: 设置界面
extension JPTestViewController {
    
    //TODO: 重写父类方法
    override func setUpTableView() {
        super.setUpTableView()
        
        //设置导航栏 左边按钮
        JPNavigationItem.rightBarButtonItem = UIBarButtonItem(title: "下一个", target: self, action: #selector(showNext)
        )
    }
}

