//
//  JPComposeNewWeiboController.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/12/7.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit
import SVProgressHUD

class JPComposeNewWeiboController: UIViewController {

    /// 底部工具栏
    @IBOutlet weak var toolBar: UIToolbar!
    
    /// 文本编辑器
    @IBOutlet weak var textView: JPComposeTextView!
    
    /// 底部工具栏的高度约束
    @IBOutlet weak var toolBarBottomCons: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()

        ///监听键盘的弹出
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChangeFrame),
                                               name: Notification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
        //注册通知 textView 的变化
        NotificationCenter.default.addObserver(self, selector: #selector(textViewTextDidChange), name: NSNotification.Name.UITextViewTextDidChange, object: textView)
    }
    
    //视图将要加载
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textView.becomeFirstResponder()
    }
    //视图将要消失
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        textView.resignFirstResponder()
    }
    deinit {
        //移除通知
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func textViewTextDidChange() {
        
        sendBtn.isEnabled = textView.hasText
    }

    
    @objc fileprivate func keyboardWillChangeFrame(noti: Notification) {
        
        
        //拿到键盘的rect 和 键盘的动画时间
        guard let rect = (noti.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = (noti.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
            
        else {
            return
        }
        
        //计算工具栏需要的位移
        let offset = view.bounds.height - rect.origin.y
        
        toolBarBottomCons.constant = offset
        
        //动画更新约束
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc fileprivate func closeView() {
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
        
        btn.addTarget(self, action: #selector(sendStatus), for: .touchUpInside)
        
        btn.frame = CGRect(x: 0, y: 0, width: 45, height: 35)
        
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
    
    /// 发送微博
    @objc fileprivate func sendStatus() {
        
        //获取微博文字
        guard let text = textView.text else {
            return
        }
        
        //发布微博
        JPNetworkManager.sharedManager.postStatus(text: text) { (data, isSuccess) in
            
            SVProgressHUD.setDefaultStyle(.dark)
            if isSuccess {
                SVProgressHUD.showSuccess(withStatus: "发送成功")
                self.sendBtn.isEnabled = false
                DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                    self.closeView()
                    SVProgressHUD.setDefaultStyle(.light)
                })
            }else {
                SVProgressHUD.showSuccess(withStatus: "发送失败")
                SVProgressHUD.setDefaultStyle(.light)
            }
        }
    }
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
