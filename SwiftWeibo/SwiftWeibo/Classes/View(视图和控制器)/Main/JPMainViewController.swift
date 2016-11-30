//
//  JPMainViewController.swift
//  SwiftWeibo
//
//  Created by Keep丶Dream on 16/11/19.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit
import SVProgressHUD

/// 主控制器
class JPMainViewController: UITabBarController {
    
    //私有控件 按钮 懒加载
    //MARK: - 加号按钮
    fileprivate lazy var plusBtn: UIButton = UIButton(imageName: "tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button", highlightName: "_highlighted")
    /// 定时器
    fileprivate var mainTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpChildCtrl()
        setUpPlusBtn()
        setUpTimer()
        
        setUpNewFeatureViews()
        
        delegate = self
        
        //注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(userLogin), name: NSNotification.Name(rawValue: JPUserShouldLoginNotification), object: nil)
    }
    
    //MARK: 代码控制设备方向
    //portrait : 竖屏
    //landscape: 横屏
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    //MARK: -按钮的点击事件
    @objc fileprivate func plusBtnSelect()  {
        print("点击按钮")
    }
    
    //MARK: 登陆
    @objc fileprivate func userLogin(notification: Notification) {
        
        //延迟时间
        var when = DispatchTime.now()
        
        //判断 notification.object 是否有值 有值提示用户token过期 在重新登陆
        if notification.object != nil{
            //设置背景渐变
//            SVProgressHUD.setDefaultMaskType(.gradient)
//            SVProgressHUD.showInfo(withStatus: "用户登录权限超时,需要重新登录")
            when = DispatchTime.now() + 1.5
        }
        //延时跳转
        DispatchQueue.main.asyncAfter(deadline:when) {
            
            let loginVC = JPOAuthViewController()
            let NavVC = UINavigationController(rootViewController: loginVC)
            self.present(NavVC, animated: true, completion: nil)
        }
        
    }
    
    deinit {
        /// 销毁时钟
        mainTimer?.invalidate()
        
        /// 销毁通知
        NotificationCenter.default.removeObserver(self)
    }
}
// 相当于OC中的分类  在swift中有分割代码块的作用
// 可以把功能相似的模块放在一个 extension中 便于管理
    //MARK: - 设置界面
extension JPMainViewController {
    
    fileprivate func setUpPlusBtn() {
        
        tabBar.addSubview(plusBtn)
        
        let count = childViewControllers.count
        
        let btnW = tabBar.bounds.width / CGFloat(count)//解决两个按钮之间的一个点的容错点 代理方法中解决
        
        //缩进 正数向内缩进 负数向外缩进
        plusBtn.frame = tabBar.bounds.insetBy(dx: 2*btnW, dy: 0)
        plusBtn.layer.cornerRadius = 5
        plusBtn.addTarget(self, action: #selector(plusBtnSelect), for: .touchUpInside)
    }
    
     fileprivate func setUpChildCtrl() {
        
        //沙盒路径
        var jsondata = NSData(contentsOfFile: weiboMainPath ?? "")
        
        if jsondata == nil {
            //从bundle中加载
            let infoPath = Bundle.main.path(forResource: "weibomain.json", ofType: nil)
            jsondata = NSData(contentsOfFile: infoPath!)
        }
        
        
        // [[String: Any]] 字典数组格式
        guard let array = try? JSONSerialization.jsonObject(with: jsondata! as Data, options: []) as? [[String: Any]]
        else{
            return
        }
        
        
        //将array格式化
//        let data = try! JSONSerialization.data(withJSONObject: array, options: .prettyPrinted)
//        (data as NSData).write(toFile: "/Users/dongjiangpeng/Desktop/weibomain.json", atomically: true)
        
        var controllers = [UIViewController]()

        for dict in array! {
            
            controllers.append(childController(dict))
        }
        
        viewControllers = controllers
    }
    
    
    /// 创建一个子控制器
    ///
    /// - Parameter dict: 信息
    fileprivate func childController(_ dict: [String : Any]) -> UIViewController {
    
        guard let className = dict["className"] as? String,
              let classTitle = dict["classTitle"] as? String,
              let imageName = dict["imageName"] as? String,
              let clsCtrl = NSClassFromString( Bundle.main.nameSpace(className)) as? JPBaseViewController.Type,
              let visitorDict = dict["visitorInfo"] as? [String: String]
        
        else {
            
            return UIViewController()
        }
        
        let vc = clsCtrl.init()
        
        //设置访客模式下的信息字典
        vc.visitorInfo_Base = visitorDict
        
        //设置标题
        vc.title = classTitle
        //设置图片
        vc.tabBarItem.image = UIImage(named: "tabbar_" + imageName)
        vc.tabBarItem.selectedImage = UIImage(named: "tabbar_" + imageName + "_selected")?.withRenderingMode(.alwaysOriginal)
        //设置字体(默认的font是12)
        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.orange], for: .selected)
        vc.tabBarItem.setTitleTextAttributes([NSFontAttributeName : UIFont.systemFont(ofSize: 12)], for: .normal)
        
        //此处会调用push方法 将rootcontroller作为压栈
        let nav = JPNavigationController(rootViewController: vc)
        
        return nav
        
        
    }
        
}

// MARK: - UITabBarControllerDelegate
extension JPMainViewController:UITabBarControllerDelegate {
    
    /// 将要选择的 TabBarItem
    ///
    /// - Parameters:
    ///   - tabBarController: tabBarController description
    ///   - viewController: 目标控制器 将要切换的
    /// - Returns: 是否切换到目标控制器
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        /// 获取目标控制器的索引
        let index = (childViewControllers as NSArray).index(of: viewController)
        /// 当前控制器的索引
        if selectedIndex == 0 && index == selectedIndex {
            
            //拿到首页控制器
            let homeNav = childViewControllers.first as! JPNavigationController
            let homeVC = homeNav.childViewControllers.first as! JPHomeController
            //滚动到顶部
            homeVC.tableView?.setContentOffset(CGPoint(x: 0,y: -64), animated: true)
            //刷新数据
            DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                homeVC.loadData()
            })
        }
        
        //此处解决是否是点击了容错点 判断目标控制器是不是(UIViewController)
        return !viewController.isMember(of: UIViewController.self)
    }
}

// MARK: - 时钟设置
extension JPMainViewController {
    
    /// 设置时钟
    fileprivate func setUpTimer() {
        
        mainTimer = Timer.scheduledTimer(timeInterval: 100.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    /// 时钟更新 调用接口
    @objc fileprivate func updateTimer() {
        
        //如果是未登录则直接return
        if !JPNetworkManager.sharedManager.userLogon {
            return
        }
        
        /// 未读微博数
        JPNetworkManager.sharedManager.unreadCount { (unreadCount) in
            print("未读微博数: \(unreadCount)")
            self.tabBar.items?.first?.badgeValue = unreadCount > 0 ? "\(unreadCount)" : nil
            
            UIApplication.shared.applicationIconBadgeNumber = unreadCount
        }
    }
}

// MARK: - 设置新特性界面视图
extension JPMainViewController {
    
    fileprivate func setUpNewFeatureViews() {
        
        //检查版本是否更新
        //如果更新 显示新特性 否则显示欢迎
        let firstView = isNewVersion ? JPNewFeatureView() : JPWelcomeView()
        firstView.frame = view.bounds
        //添加视图
        view.addSubview(firstView)
    }
    
    /// extension 中可以存在计算型属性
    fileprivate var isNewVersion: Bool {
        
        //取出当前的版本号
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

        //取出保存在本地 (Document iTunes备份的)中保存的版本号
        let sandboxVersion = try? String(contentsOfFile: currentVersionPath!)
        
        //将当前的版本号保存在沙盒中
        try? currentVersion?.write(toFile: currentVersionPath!, atomically: true, encoding: .utf8)
        //比较两个版本号
        return currentVersion != sandboxVersion
        
    }
}
