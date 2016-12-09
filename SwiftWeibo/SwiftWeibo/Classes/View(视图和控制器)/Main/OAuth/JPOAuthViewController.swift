//
//  JPOAuthViewController.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/11/24.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit
import SVProgressHUD

class JPOAuthViewController: UIViewController {

    fileprivate lazy var webView = UIWebView()
    
    override func loadView() {
        
        view = webView
        view.backgroundColor = UIColor.white
        
        webView.delegate = self
        //设置导航栏
        title = "登录新浪微博"

        let backItem = UIBarButtonItem(title: "返回", fontSize: 15, target: self, action: #selector(loginBack), isBackButton: true)
        //为了向左缩进
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spaceItem.width = -10
        navigationItem.leftBarButtonItems = [spaceItem,backItem]
        
        let rightItem = UIBarButtonItem(title: "自动填充", fontSize: 15, target: self, action: #selector(autoFill))
        navigationItem.rightBarButtonItem = rightItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //加载授权界面
        //拼接请求地址
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(SinaClient_id)&redirect_uri=\(SinaRedirect_uri)"
        //确定要访问的URL地址
        guard let url = URL(string: urlString) else {
            return
        }
        //建立请求
        let request = URLRequest(url: url)
        //加载请求
        webView.loadRequest(request)
        
    }
    
    @objc fileprivate func loginBack() {
        
        SVProgressHUD.dismiss()
        dismiss(animated: true, completion: nil)
    }

    @objc fileprivate func autoFill() {
        
        let js = "document.getElementById('userId').value = '13693687393';" + "document.getElementById('passwd').value = '';"
        
        webView.stringByEvaluatingJavaScript(from: js)
    }
    

}

extension JPOAuthViewController: UIWebViewDelegate {
    
    /// webView  将要加载请求
    ///
    /// - Parameters:
    ///   - webView: webView description
    ///   - request: 要加载的请求
    ///   - navigationType: 导航类型
    /// - Returns: 是否加载request
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
//        print("加载请求--\(request.url?.absoluteString)")
        //判断加载请求是否存在回到地址 
        if request.url?.absoluteString.hasPrefix(SinaRedirect_uri) == false {
            return true
        }
        //query 是显示 '?' 后面的全部内容
        let query = request.url?.query
        //判断加载请求中是否存在 code= 存在授权成功 不存在授权失败
        if query?.hasPrefix("code=") == false {
            
            print("授权失败或者取消")
            loginBack()
            return false
        }
        let code = query?.substring(from: "code=".endIndex)
        
        JPNetworkManager.sharedManager.getToken(code: code!) { (isSuccess) in
            if isSuccess {
                SVProgressHUD.showSuccess(withStatus: "登陆成功")
                //发送通知
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: JPUserLoginSuccessNotification), object: nil)
                //关闭当前控制器
                self.loginBack()
            }else{
                SVProgressHUD.showError(withStatus: "网络请求失败")
            }
        }
        return false
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
}
