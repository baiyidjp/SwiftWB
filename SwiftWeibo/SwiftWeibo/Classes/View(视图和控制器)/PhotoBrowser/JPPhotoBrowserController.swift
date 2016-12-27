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
        
        print(selectedIndex)
        print(urls)

    }
    
    @objc fileprivate func tapPhotoView() {
        
        dismiss(animated: true, completion: nil)
    }
}

fileprivate extension JPPhotoBrowserController {
    
    func setupUI() {
        
        view.backgroundColor = UIColor.red;
        //添加子控制器
        //1->实例化子控制器
        let photoView = JPPhotoViewController(urlString: urls[selectedIndex], selectedIndex: selectedIndex)
        //2->将子控制器的View添加到当前的View上
        view.addSubview(photoView.view)
        //3->将子控制器添加到当前的控制器
        addChildViewController(photoView)
        //4->通知当前控制器已经添加完成
        photoView.didMove(toParentViewController: self)
        
        //添加photoView的点击手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapPhotoView))
        photoView.view.addGestureRecognizer(tap)
        
        
    }
}
