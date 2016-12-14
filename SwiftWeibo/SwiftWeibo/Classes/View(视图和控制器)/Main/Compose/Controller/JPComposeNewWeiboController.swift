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
    
    /// 懒加载表情界面
    // emoticonModel 闭包传回的选中的表情的模型数据
    lazy var emoticonView: JPEmoticonView = JPEmoticonView.emoticonView { [weak self] (emoticonModel) in
        
        self?.insertEmoticon(emoticonModel: emoticonModel)
    }
    
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
        
        emoticonStringText()
        return
        //获取微博文字
        guard let text = textView.text else {
            return
        }
        
        //发布微博
//        let image = #imageLiteral(resourceName: "deliveryStaff")
        let image: UIImage? = nil
        JPNetworkManager.sharedManager.postStatus(text: text,image: image) { (data, isSuccess) in
            
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
    
    /// 表情点击
    @objc fileprivate func emoticonClick() {
        
        //替换原有的textview的inputview
        textView.inputView = (textView.inputView == nil) ? emoticonView : nil
        
        //刷新inputview
        textView.reloadInputViews()
    }
    
    /// 插入表情(图文混排)
    ///
    /// - Parameter emoticonModel: nil为删除键
    func insertEmoticon(emoticonModel:JPEmoticonModel?) {
        
        print("VC--\(emoticonModel)")
        
        //若为nil 删除
        guard let emoticonModel = emoticonModel else {
            
            textView.deleteBackward()
            return
        }
        
        //是否是emoji 字符串
        if let emoji = emoticonModel.emoji,
            let textRange = textView.selectedTextRange {
            
            //插入emoji字符串
            textView.replace(textRange, withText: emoji)
            return
        }
        
        //走到此处 都是图片表情
        //1-拿到图片表情对应的属性文本
        let imageText = emoticonModel.imageText(font: textView.font!)
        
        //2-使用当前textview的文本内容创建一个新的属性文本 用来接收图片的属性文本
        let attributeText = NSMutableAttributedString(attributedString: textView.attributedText)
        
        //3-更新属性文本
            //记录当前鼠标的位置
        let range = textView.selectedRange
            //插入表情文本
        attributeText.replaceCharacters(in: range, with: imageText)
        
        //4-恢复文本 光标位置
        textView.attributedText = attributeText
            //range的length是选中的文本的长度 重新设置时应该为0
        textView.selectedRange = NSRange(location: range.location+1, length: 0)
    }
    
    /// 将textview的属性文本 转换成 纯 文字的文本
    ///
    /// - Returns: 纯文字的文本
    func emoticonStringText() -> String {
        
        //用来接收转换的文本
        var resultText = String()
        
        //获取textview的属性文本
        guard let attritubeText = textView.attributedText else {
            return resultText
        }
        //遍历属性文本
        attritubeText.enumerateAttributes(in: NSRange(location: 0, length: (attritubeText.length)), options: [], using: { (dict, range, _) in
            
            //表情字符的 dict 中 存在 NSAttachment 便是表情字符
            if let textAttachment = dict["NSAttachment"] {
                resultText += (textAttachment as! JPTextAttachment).chs ?? ""
            }else {
                let subStr = (attritubeText.string as NSString).substring(with: range)
                resultText += subStr
            }
        })
        print(resultText)
        return resultText
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
                         ["imageName":"compose_emoticonbutton_background","actionName":"emoticonClick"],
                         ["imageName":"compose_toolbar_more"]]
        
        //存放 底部的item
        var items = [UIBarButtonItem]()
        
        for dict in itemsName {
            
            guard let imageName = dict["imageName"] else {
                //继续下一个循环
                continue
            }
            
            let btn = UIButton(imageName: imageName, highlightName: "_highlighted")
            
            if let actionName = dict["actionName"] {
                
                btn.addTarget(self, action: Selector(actionName), for: .touchUpInside)
            }
            
            items.append(UIBarButtonItem(customView: btn))
            //追加弹簧
            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        //删除最后一个弹簧
        items.removeLast()
        
        toolBar.items = items
    }
}
