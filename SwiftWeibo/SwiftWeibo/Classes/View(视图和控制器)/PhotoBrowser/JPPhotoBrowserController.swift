//
//  JPPhotoBrowserController.swift
//  SwiftWeibo
//
//  Created by Keep丶Dream on 16/12/27.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit
import SVProgressHUD

/// 照片浏览控制器 负责用户交互
class JPPhotoBrowserController: UIViewController {
    
    /// 顶部提示
    fileprivate lazy var tipCountLabel: UILabel = UILabel(text: "", fontSize: 15, textColor: UIColor.darkGray, textAlignment: .center)
    /// 保存按钮
    fileprivate lazy var saveButton: UIButton = UIButton()

    /// 当前图片的下标
    fileprivate var selectedIndex: Int
    /// URL的集合
    fileprivate let urls: [String]
    /// imageView的集合
    fileprivate let imageViews: [UIImageView]
    /// 转场动画代理
    private let animator: JPPhotoBrowserAnimator
    /// 记录当前的图片控制器
    fileprivate var currentPhotoCtrl: JPPhotoViewController?
    
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
        attributeStr.addAttributes([NSForegroundColorAttributeName:UIColor.red], range: NSMakeRange(0, 1))
        tipCountLabel.font = UIFont.boldSystemFont(ofSize: 18)
        tipCountLabel.attributedText = attributeStr
    }
    
    /// 保存图片
    @objc fileprivate func saveImage() {
        
        // 1. 取出图像
        guard let image = currentPhotoCtrl?.imageV.image  else {
            return
        }
        // 2. 保存图像
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    //  - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        
        let message = (error == nil) ? "保存成功" : "保存失败"
        
        SVProgressHUD.showSuccess(withStatus: message)
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
        let photoView = JPPhotoViewController(urlString: urls[selectedIndex], selectedIndex: selectedIndex,placeholderImage: imageViews[selectedIndex].image!)
        photoView.delegate = self
        currentPhotoCtrl = photoView
        //--2->设置子控制器 初始化当前显示的控制器 只有一个
        pageViewController.setViewControllers([photoView], direction: .forward, animated: false, completion: nil)
        
        //3->将分页控制器添加为当前控制器的子控制器
        view.addSubview(pageViewController.view)
        addChildViewController(pageViewController)
        pageViewController.didMove(toParentViewController: self)
        
        //4->设置手势识别
        view.gestureRecognizers = pageViewController.gestureRecognizers
        
        //5->设置数据源 代理
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
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
        
        //保存按钮
        saveButton.setTitle("保存", for: .normal)
        saveButton.backgroundColor = UIColor.black
        saveButton.layer.cornerRadius = 5
        saveButton.layer.borderWidth = 1
        saveButton.layer.borderColor = UIColor.white.cgColor
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(tipCountLabel.snp.centerY)
            make.right.equalTo(-20)
            make.size.equalTo(CGSize(width: 50, height: 25))
        }
        saveButton.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
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
        //判断是否到头
        if index <= 0 {
            return nil
        }
        
        //计算前一页控制器的索引并实例化一个控制器
        index -= 1

        let photoView = JPPhotoViewController(urlString: urls[index], selectedIndex: index,placeholderImage: imageViews[index].image!)
        photoView.delegate = self
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
        
        //判断是否到头
        index += 1
        if index >= urls.count {
            return nil
        }
        //计算后一页控制器的索引并实例化一个控制器
        let photoView = JPPhotoViewController(urlString: urls[index], selectedIndex: index,placeholderImage: imageViews[index].image!)
        photoView.delegate = self
        //返回实例化的显示图片的控制器
        return photoView

    }
    
}

// MARK: - UIPageViewControllerDelegate
extension JPPhotoBrowserController: UIPageViewControllerDelegate {
    
    /// 分页停止动画 - 第一次启动，不会调用此代理方法
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        // viewControllers[0] 是当前显示的控制器，随着分页控制器的滚动，调整数组的内容次序
        // 始终保证当前显示的控制器的下标是 0
        // 一定注意，不要使用 childViewControllers

        guard let photoView = pageViewController.viewControllers?[0] as? JPPhotoViewController else {
            return
        }
        //记录当前的控制器
        currentPhotoCtrl = photoView
        let index = photoView.selectedIndex
        //记录当前图片的下标
        selectedIndex = index
        //改变提示label
        setTipLabel(index: index)
    }
}

// MARK: - JPPhotoViewControllerDelegate
extension JPPhotoBrowserController: JPPhotoViewControllerDelegate {
    
    func photoViewControllerImageViewTap() {
        
        tapPhotoView()
    }
}
