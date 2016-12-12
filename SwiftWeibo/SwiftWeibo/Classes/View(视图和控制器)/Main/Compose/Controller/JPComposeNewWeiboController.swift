//
//  JPComposeNewWeiboController.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/12/7.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit

class JPComposeNewWeiboController: UIViewController {

    /// 底部工具栏
    @IBOutlet weak var toolBar: UIToolbar!
    
    /// 文本编辑器
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()

        ///监听键盘的弹出
        NotificationCenter.default.addObserver(self, selector: #selector(textChange), name: Notification.Name.UITextViewTextDidChange, object: nil)
    }
    
    deinit {
        //移除通知
        NotificationCenter.default.removeObserver(self)
    }
    
    func textChange(noti: Notification) {
        
        print(noti)
    }
    
    func closeView() {
        dismiss(animated: true, completion: nil)
    }
    
    //懒加载button
    lazy var sendBtn: UIButton = {
        
        let btn = UIButton(type: .custom)
        
        btn.setTitle("发布", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.layer.cornerRadius = 2
        btn.layer.masksToBounds = true
        
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitleColor(UIColor.darkGray, for: .disabled)
        
        btn.setBackgroundImage(#imageLiteral(resourceName: "compose_guide_button_default"), for: .normal)
        btn.setBackgroundImage(#imageLiteral(resourceName: "compose_guide_button_check"), for: .highlighted)
        btn.setBackgroundImage(#imageLiteral(resourceName: "common_button_white_disable"), for: .disabled)
        
        btn.frame = CGRect(x: 0, y: 0, width: 45, height: 30)
        
        return btn
    }()
    
    //懒加载titleView
    lazy var titleView : UIView = {
        
        let view = UIView()
        
        let topLable = UILabel(text: "发微博", fontSize: 15, textColor: UIColor.black, textAlignment: .center)
        //加粗
        topLable.font = UIFont.boldSystemFont(ofSize: 15)
        let bottomLable = UILabel(text: JPNetworkManager.sharedManager.userAccount.screen_name ?? ""
 , fontSize: 13, textColor: UIColor.lightGray, textAlignment: .center)
        
        view.addSubview(topLable)
        view.addSubview(bottomLable)
        
        topLable.snp.makeConstraints({ (make) in
            make.top.equalTo(view)
            make.centerX.equalTo(view)
        })
        
        bottomLable.snp.makeConstraints({ (make) in
            make.top.equalTo(topLable.snp.bottom).offset(1)
            make.centerX.equalTo(view)
        })
        
        view.bounds.size = CGSize(width: 100, height: 30)
        
        return view
    }()
}

// MARK: - 设置界面
fileprivate extension JPComposeNewWeiboController {
    
    func setupUI() {
        
        setItem()
        setupBottomItems()
    }
    
    func setItem() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", target: self, action: #selector(closeView))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sendBtn)
        sendBtn.isEnabled = false
        //设置titleView
        navigationItem.titleView = titleView
        
    }
    
    func setupBottomItems() {
        
        let itemsName = [["imageName":"compose_toolbar_picture"],
                         ["imageName":"compose_mentionbutton_background"],
                         ["imageName":"compose_trendbutton_background"],
                         ["imageName":"compose_emoticonbutton_background"],
                         ["imageName":"compose_toolbar_more"]]
        
        //存放 底部的item
        var items = [UIBarButtonItem]()
        
        for dict in itemsName {
            
            guard let imageName = dict["imageName"] else {
                //继续下一个循环
                continue
            }
            
            let btn = UIButton(imageName: imageName, highlightName: "_highlighted")
            
            items.append(UIBarButtonItem(customView: btn))
            //追加弹簧
            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        //删除最后一个弹簧
        items.removeLast()
        
        toolBar.items = items
    }
}
