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
    
    /// 顶部提示
    fileprivate lazy var tipCountLabel: UILabel = UILabel(text: "", fontSize: 15, textColor: UIColor.white, textAlignment: .center)
    
    /// 当前图片的下标
    fileprivate var selectedIndex: Int
    /// URL的集合
    fileprivate let urls: [String]
    
    fileprivate let imageViews: [UIImageView]
    
    private let animator: JPPhotoBrowserAnimator
    
    init(selectedIndex: Int,urls: [String],imageViews: [UIImageView]) {
        
        self.selectedIndex = selectedIndex
        self.urls = urls
        self.imageViews = imageViews
        
        //实例化转场代理
        animator = JPPhotoBrowserAnimator()
        animator.presentingImageView = imageViews[selectedIndex]
        //调用父类的构造函数
        super.init(nibName: nil, bundle: nil)
        //代理是父类的方法 所以需要写在父类之后
        transitioningDelegate = animator
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    /// 退出当前视图
    @objc fileprivate func tapPhotoView() {
        animator.presentingImageView = imageViews[selectedIndex]
        dismiss(animated: true, completion: nil)
    }
    
    /// 设置顶部提示的文本
    fileprivate func setTipLabel(index: Int) {
        
        let allCount = urls.count
        let str = "\(index+1) / \(allCount)"
        
        let attributeStr = NSMutableAttributedString(string: str)
        attributeStr.addAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 17)], range: NSMakeRange(0, 1))
        tipCountLabel.attributedText = attributeStr
    }
}

fileprivate extension JPPhotoBrowserController {
    
    func setupUI() {
        
        view.backgroundColor = UIColor.black;
        /// 添加分页控制器
        //1->实例化
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [UIPageViewControllerOptionInterPageSpacingKey:20])
        //2->添加分页控制器子控制器
        //--1->实例化子控制器
        let photoView = JPPhotoViewController(urlString: urls[selectedIndex], selectedIndex: selectedIndex)
        //--2->设置子控制器 初始化当前显示的控制器 只有一个
        pageViewController.setViewControllers([photoView], direction: .forward, animated: false, completion: nil)
        
        //3->将分页控制器添加为当前控制器的子控制器
        view.addSubview(pageViewController.view)
        addChildViewController(pageViewController)
        pageViewController.didMove(toParentViewController: self)
        
        //4->设置手势识别
        view.gestureRecognizers = pageViewController.gestureRecognizers
        
        //5->设置数据源
        pageViewController.dataSource = self
        
        //添加的点击手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapPhotoView))
        view.addGestureRecognizer(tap)
        
        if urls.count == 1 {
            tipCountLabel.isHidden = true
        }
        view.addSubview(tipCountLabel)
        tipCountLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(20)
            make.size.equalTo(CGSize(width: view.bounds.width, height: 25))
        }
        setTipLabel(index: selectedIndex)
    }
}

// MARK: - UIPageViewControllerDataSource
extension JPPhotoBrowserController: UIPageViewControllerDataSource {
    
    /// 返回前一页控制器
    ///
    /// - Parameters:
    ///   - pageViewController: pageViewController description
    ///   - viewController: 当前显示的控制器
    /// - Returns: 返回前一页控制器 返回nil 到头了
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        //拿到当前显示的控制器的索引
        var index = (viewController as! JPPhotoViewController).selectedIndex
        //记录当前图片的下标
        selectedIndex = index
        //改变提示label
        setTipLabel(index: index)
        print(index)
        //判断是否到头
        if index <= 0 {
            return nil
        }
        
        //计算前一页控制器的索引并实例化一个控制器
        index -= 1

        let photoView = JPPhotoViewController(urlString: urls[index], selectedIndex: index)
        //返回实例化的显示图片的控制器
        return photoView
        
    }
    
    /// 返回后一页
    ///
    /// - Parameters:
    ///   - pageViewController: pageViewController description
    ///   - viewController: 当前显示的控制器
    /// - Returns: 返回后一页的控制器 返回nil 到头了
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        //拿到当前显示的控制器的索引
        var index = (viewController as! JPPhotoViewController).selectedIndex
        //记录当前图片的下标
        selectedIndex = index
        //改变提示label
        setTipLabel(index: index)
        print(index)
        //判断是否到头
        index += 1
        if index >= urls.count {
            return nil
        }
        //计算后一页控制器的索引并实例化一个控制器
        let photoView = JPPhotoViewController(urlString: urls[index], selectedIndex: index)
        //返回实例化的显示图片的控制器
        return photoView

    }
    
}
