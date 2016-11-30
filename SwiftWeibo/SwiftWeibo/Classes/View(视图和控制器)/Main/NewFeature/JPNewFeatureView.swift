//
//  JPNewFeatureView.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/11/28.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit

let imageCount = 4
class JPNewFeatureView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -懒加载view
    /// scrollView
    fileprivate lazy var newScrollView: UIScrollView = UIScrollView()
    /// 进入微博按钮
    fileprivate lazy var startButton: UIButton = UIButton(title: "进入微博", fontSize: 17, normalColor: UIColor.white, highlightColor: UIColor.white, backgroundImageName: "new_feature_finish_button")
    /// 分页
    fileprivate lazy var pageControl: UIPageControl = UIPageControl(numberOfPages: 4)
    
    @objc fileprivate func clickStartBtn() {
        
        removeFromSuperview()
    }
}

// MARK: - add views
extension JPNewFeatureView {
    
    fileprivate func setUpViews() {
        
        addSubview(newScrollView)
        addSubview(startButton)
        addSubview(pageControl)
        
        setScrollImageViews()
        setViewConstraints()
    }
    
    fileprivate func setViewConstraints() {
        
        startButton.isHidden = true
        startButton.addTarget(self, action: #selector(clickStartBtn), for: .touchUpInside)
        startButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(-150)
            make.size.equalTo(CGSize(width: 105, height: 36))
        }
        
        pageControl.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(startButton.snp.bottom).offset(30)
            make.width.equalTo(CGSize(width: 60, height: 20))
        }
    }
    
    fileprivate func setScrollImageViews() {
        
        
        newScrollView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(0)
        }
        newScrollView.contentSize = CGSize(width: CGFloat(imageCount+1) * ScreenWidth, height: ScreenHeight)
        newScrollView.bounces = false
        newScrollView.showsVerticalScrollIndicator = false
        newScrollView.showsHorizontalScrollIndicator = false
        newScrollView.isPagingEnabled = true
        newScrollView.isScrollEnabled = true
        newScrollView.backgroundColor = UIColor.clear
        newScrollView.delegate = self

        for i in 0..<imageCount {
            
            let name = "new_feature_\(i+1)"
            let imageLeft = CGFloat(i) * ScreenWidth
            
            let imageV = UIImageView(image: UIImage(named: name))
            newScrollView.addSubview(imageV)
            imageV.snp.makeConstraints({ (make) in
                make.top.equalTo(0)
                make.left.equalTo(imageLeft)
                make.size.equalTo(CGSize(width: ScreenWidth, height: ScreenHeight))
            })
        }
    }
}

// MARK: - UIScrollViewDelegate
extension JPNewFeatureView: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        //滚动到最后一个空白页面 移除当前视图
        let pageNum = Int(scrollView.contentOffset.x/scrollView.bounds.width)
        if pageNum == imageCount {
            removeFromSuperview()
        }
        //如果是最后一页图片则显示按钮
        startButton.isHidden = (pageNum != imageCount-1)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //滑动隐藏按钮
        startButton.isHidden = true
        //当前页
        let pageNum = Int(scrollView.contentOffset.x/scrollView.bounds.width+0.5)
        //设置分页的当前页
        pageControl.currentPage = pageNum
        //最后一页时隐藏分页
        pageControl.isHidden = (pageNum == imageCount)
    }
}
