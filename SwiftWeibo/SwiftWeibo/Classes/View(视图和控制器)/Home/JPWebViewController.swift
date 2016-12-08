//
//  JPWebViewController.swift
//  SwiftWeibo
//
//  Created by Keep丶Dream on 16/12/8.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit

class JPWebViewController: JPBaseViewController {

    
    fileprivate var webView = UIWebView(frame: UIScreen.main.bounds)
    
    /// URL字符串
    var urlStr: String? {
        
        didSet {
        
            guard let urlStr = self.urlStr,
                let url = URL(string: urlStr)
                else {
                    return 
            }
            
            webView.loadRequest(URLRequest(url: url))
        }
    }
}

extension JPWebViewController {
    
    override func setUpTableView() {
        
        //设置标题
        JPNavigationItem.title = "网页网页"
        
        //设置webView
        view.insertSubview(webView, belowSubview: JPNavigationBar)
        
        webView.backgroundColor = UIColor.white
        
        //设置contentInset
        webView.scrollView.contentInset.top = JPNavigationBar.bounds.height
    }
}
