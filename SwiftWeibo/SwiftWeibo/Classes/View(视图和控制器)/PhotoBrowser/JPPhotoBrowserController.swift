//
//  JPPhotoBrowserController.swift
//  SwiftWeibo
//
//  Created by Keep丶Dream on 16/12/27.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit

/// 照片浏览控制器 负责用户交互
class JPPhotoBrowserController: UIViewController {
    
    /// 选中的图片的下标
    fileprivate let selectedIndex: Int
    /// URL的集合
    fileprivate let urls: [String]
    
    init(selectedIndex: Int,urls: [String]) {
        
        self.selectedIndex = selectedIndex
        self.urls = urls
        //调用父类的构造函数
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    @objc fileprivate func tapPhotoView() {
        
        dismiss(animated: true, completion: nil)
    }
}

fileprivate extension JPPhotoBrowserController {
    
    func setupUI() {
        
        view.backgroundColor = UIColor.red;
        
        /// 添加分页控制器
        //1->实例化
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [UIPageViewControllerOptionInterPageSpacingKey:20])
        //2->添加分页控制器子控制器
        //--1->实例化子控制器
        let photoView = JPPhotoViewController(urlString: urls[selectedIndex], selectedIndex: selectedIndex)
        //--2->设置子控制器
        pageViewController.setViewControllers([photoView], direction: .forward, animated: false, completion: nil)
        
        //3->将分页控制器添加为当前控制器的子控制器
        view.addSubview(pageViewController.view)
        addChildViewController(pageViewController)
        pageViewController.didMove(toParentViewController: self)
        
        //4->设置手势识别
        view.gestureRecognizers = pageViewController.gestureRecognizers
        
        //添加photoView的点击手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapPhotoView))
        photoView.view.addGestureRecognizer(tap)
        
        
        
    }
}
