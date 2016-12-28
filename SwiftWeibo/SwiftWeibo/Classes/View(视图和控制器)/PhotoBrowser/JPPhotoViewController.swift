//
//  JPPhotoViewController.swift
//  SwiftWeibo
//
//  Created by Keep丶Dream on 16/12/27.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit
import SDWebImage

/// 单击图片的代理
@objc protocol JPPhotoViewControllerDelegate: NSObjectProtocol {
    
    func photoViewControllerImageViewTap()
}

/// 负责单张照片的显示
class JPPhotoViewController: UIViewController {
    
    /// 代理
    var delegate: JPPhotoViewControllerDelegate?
    
    /// 懒加载滚动视图 和 图片视图
    fileprivate lazy var scrollView = UIScrollView()
    lazy var imageV = UIImageView()
    
    /// 图片的URL 和 下标
    fileprivate let urlString: String
    let selectedIndex: Int
    fileprivate let placeholderImage: UIImage
    
    
    //构造函数
    init(urlString: String,selectedIndex: Int,placeholderImage: UIImage) {
        self.selectedIndex = selectedIndex
        self.urlString = urlString
        self.placeholderImage = placeholderImage
        
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
        imageV.setShowActivityIndicator(true)
        imageV.sd_setImage(with: url, placeholderImage: placeholderImage, options: []) { (image, _, _, _) in
            
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
    fileprivate func setImageSize(image: UIImage,scale: CGFloat = 1) {
        
        //屏幕尺寸
        let screenSize = UIScreen.main.bounds.size
        //原始图片尺寸
        let imageSize = image.size
        //适配尺寸
        var size = CGSize()
        // 根据屏幕的宽度计算图片的高度
        size.width = screenSize.width*scale
        size.height = imageSize.height * size.width / imageSize.width
        //设置frame
        imageV.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        //设置scrollView的滚动范围
        scrollView.contentSize = size
        //设置短图居中显示
        if size.height < scrollView.bounds.size.height*scale {
            imageV.frame.origin.y = (scrollView.bounds.size.height - size.height)*0.5
            if imageV.frame.origin.y < 0 {
                imageV.frame.origin.y = 0
            }
        }
    }
    /// 单击图片 关闭
    @objc fileprivate func oneTapImageView() {
        //代理-Browser中
        delegate?.photoViewControllerImageViewTap()
    }

    
    /// 双击图片 放大
    @objc fileprivate func doubleTapImageView(gesture: UITapGestureRecognizer) {
        print("双击")
        
        let scale: CGFloat = scrollView.zoomScale < 2 ? 2 : 1
        UIView .animate(withDuration: 0.3, animations: {
            
            self.scrollView.zoomScale = scale
            
        })
    }
    
    /// 控制器消失时 恢复图片的缩放为1
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        scrollView.zoomScale = 1
    }
    
}

fileprivate extension JPPhotoViewController {
    
    func setupUI() {
        
        view.backgroundColor = UIColor.black
        view.addSubview(scrollView)
        //设置scrol的bounds
        scrollView.frame = view.bounds
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 2
        
        //设置初始位置
        setImageSize(image: placeholderImage)
        
        scrollView.addSubview(imageV)
        //开启交互
        imageV.isUserInteractionEnabled = true
        //添加手势 单击 / 双击 / 缩放
        let oneTap = UITapGestureRecognizer(target: self, action: #selector(oneTapImageView))
        oneTap.numberOfTapsRequired = 1

        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapImageView))
        doubleTap.numberOfTapsRequired = 2
        
        oneTap.require(toFail: doubleTap)
        
        imageV.addGestureRecognizer(oneTap)
        imageV.addGestureRecognizer(doubleTap)
        
    }
}

// MARK: - UIScrollViewDelegate
extension JPPhotoViewController: UIScrollViewDelegate {
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        //缩放中根据scale改变imageView的frame
        setImageSize(image: imageV.image!, scale: scrollView.zoomScale)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        print("viewForZooming")
        return imageV
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        print("scrollViewWillBeginZooming")
        
    }
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        print("scrollViewDidEndZooming")

    }
}
