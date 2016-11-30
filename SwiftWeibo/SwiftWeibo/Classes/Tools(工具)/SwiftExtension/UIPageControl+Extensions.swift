//
//  UIPageControl+Extensions.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/11/28.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import Foundation

extension UIPageControl {
    
    /// UIPageControl
    ///
    /// - Parameters:
    ///   - frame: 布局
    ///   - numberOfPages: 总页数
    ///   - currentPage: 当前页数
    ///   - pageIndicatorTintColor: 未选中页颜色
    ///   - currentPageIndicatorTintColor: 当前选中页颜色
    convenience init(numberOfPages: Int = 0,currentPage: Int = 0,pageIndicatorTintColor: UIColor = UIColor.black,currentPageIndicatorTintColor :UIColor = UIColor.orange) {
        self.init()

        self.numberOfPages = numberOfPages
        self.currentPage = currentPage
        self.pageIndicatorTintColor = pageIndicatorTintColor
        self.currentPageIndicatorTintColor = currentPageIndicatorTintColor
    }
}
