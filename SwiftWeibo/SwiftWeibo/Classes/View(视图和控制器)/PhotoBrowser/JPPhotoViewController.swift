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
    fileprivate lazy var imageV = UIImageView()
    
    /// 图片的URL 和 下标
    fileprivate let urlString: String
    let selectedIndex: Int
    
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
        loadImage()
    }
    
    /// 加载图片  通过usrString
    fileprivate func loadImage() {
        
        guard let url = URL(string: urlString) else {
            return
        }
        // reference to member 'sd_setImage(with:placeholderImage:options:)'
        imageV.sd_setImage(with: url, placeholderImage: UIImage(named: ""), options: []) { (image, _, _, _) in
            
            guard let image = image  else {
                return
            }
            //根据图片尺寸设置imageView的尺寸
            self.setImageSize(image: image)
        }
    }
    
    /// 根据图片设置 imageView的尺寸
    ///
    /// - Parameter image:
    fileprivate func setImageSize(image: UIImage) {
        
        var size = UIScreen.main.bounds.size
        // 根据屏幕的宽度计算图片的高度
        size.height = image.size.height * size.width / image.size.width
        //设置frame
        imageV.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        //设置scrollView的滚动范围
        scrollView.contentSize = size
        //设置短图居中显示
        if size.height < scrollView.bounds.size.height {
            imageV.frame.origin.y = (scrollView.bounds.size.height - size.height)*0.5
        }
    }
}

fileprivate extension JPPhotoViewController {
    
    func setupUI() {
        
        view.backgroundColor = UIColor.white
        
        view.addSubview(scrollView)
        //设置scrol的bounds
        scrollView.frame = view.bounds
        
        scrollView.addSubview(imageV)
    }
}
