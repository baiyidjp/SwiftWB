//
//  JPPhotoViewController.swift
//  SwiftWeibo
//
//  Created by Keep丶Dream on 16/12/27.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit
import SDWebImage

/// 负责单张照片的显示
class JPPhotoViewController: UIViewController {
    
    /// 懒加载滚动视图 和 图片视图
    fileprivate lazy var scrollView = UIScrollView()
    fileprivate lazy var imageView = UIImageView()
    
    /// 图片的URL 和 下标
    fileprivate let urlString: String
    fileprivate let selectedIndex: Int
    
    //构造函数
    init(urlString: String,selectedIndex: Int) {
        self.selectedIndex = selectedIndex
        self.urlString = urlString
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    /// 加载图片  通过usrString
    fileprivate func loadImage() {
        
        guard let url = NSURL(string: urlString) else {
            return
        }
        
        
    }
}

fileprivate extension JPPhotoViewController {
    
    func setupUI() {
        
        view.backgroundColor = #colorLiteral(red: 0.3643351197, green: 0.8083514571, blue: 0.9759570956, alpha: 1)
        
        view.addSubview(scrollView)
        //设置scrol的bounds
        scrollView.frame = view.bounds
        
        scrollView.addSubview(imageView)
    }
}
