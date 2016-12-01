//
//  JPBaseViewController.swift
//  SwiftWeibo
//
//  Created by Keep丶Dream on 16/11/19.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit

//另起一个extension 专门写代理和数据源
//extension 可以把函数按照功能分类 便于阅读和维护
//1.不能有属性  2.不能重写方法 重写是子类的任务 extension是扩展 是对类的扩展
//class JPBaseViewController: UIViewController , UITableViewDelegate ,UITableViewDataSource{
class JPBaseViewController: UIViewController{

    /// 访客视图的信息
    var visitorInfo_Base: [String : String]?
    
    /// 自定义一个导航bar
    lazy var JPNavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 64))
    /// 自定义一个导航条目
    lazy var JPNavigationItem = UINavigationItem()
    //列表
    var tableView: UITableView?
    //下拉刷新控件
    var refreshControl: UIRefreshControl?
    //是否正在上拉刷新
    var isPullup = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //清除左右item
//        JPNavigationItem.leftBarButtonItem = nil
        JPNavigationItem.rightBarButtonItem = nil
        
        //取消视图的自动缩进 20点
        automaticallyAdjustsScrollViewInsets = false
        
        //设置UI
        setUpUI()
        
        //只有登录才会加载数据
        if JPNetworkManager.sharedManager.userLogon {
            loadData()
        }
        
        //注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: NSNotification.Name(rawValue: JPUserLoginSuccessNotification), object: nil)
    }

    override var title: String? {
        // 相当于OC 的 setter
        didSet {
            JPNavigationItem.title = title
        }
    }
    
    //MARK: 加载数据  准备方法 子类去实现
    func loadData() {
        //如果子类不实现任何方法 默认关闭刷新
        refreshControl?.endRefreshing()
    }
    
    deinit {
        //注销通知
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: 设置界面
extension JPBaseViewController {
    
    fileprivate func setUpUI() {
        
        view.backgroundColor = UIColor.white
        
        //设置导航条
        setUpNavigationBar()
        //通过用户是否登录标记判断 显示哪个view
        JPNetworkManager.sharedManager.userLogon ? setUpTableView() : setUpVisitorView()
    }
    
    //设置表格视图
    func setUpTableView() {
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        view.insertSubview(tableView!, belowSubview: JPNavigationBar)
        tableView?.dataSource = self
        tableView?.delegate = self
        //设置缩进
        tableView?.contentInset = UIEdgeInsetsMake(JPNavigationBar.bounds.height, 0, tabBarController?.tabBar.bounds.height ?? 49, 0)
        //修改指示器的缩进
        tableView?.scrollIndicatorInsets = tableView!.contentInset
        
        //实例化刷新控件
        refreshControl = UIRefreshControl()
        tableView?.addSubview(refreshControl!)
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }
    
    /// 访问模式的view
    fileprivate func setUpVisitorView() {
        
        let visitorView = JPVisitorView(frame: view.bounds)
        view.insertSubview(visitorView, belowSubview: JPNavigationBar)
        visitorView.visitorInfo = visitorInfo_Base
        //添加点击事件
        visitorView.registerButton.addTarget(self, action: #selector(registerBtnClick), for: .touchUpInside)
        visitorView.loginButton.addTarget(self, action: #selector(loginBtnClick), for: .touchUpInside)
        //左右item(系统的)
        JPNavigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(registerBtnClick))
        JPNavigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(loginBtnClick))
//        let leftItem = UIBarButtonItem(title: "注册", target: self, action: #selector(registerBtnClick))
        /*
         let spaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
         spaceItem.width = -10
         JPNavigationItem.leftBarButtonItems = [spaceItem,leftItem]
         */
//        let rightItem = UIBarButtonItem(title: "登录", target: self, action: #selector(loginBtnClick))
//        JPNavigationItem.rightBarButtonItem = rightItem
    }
    
    fileprivate func setUpNavigationBar() {
        //添加导航条
        view.addSubview(JPNavigationBar)
        //将导航条目 添加到导航条
        JPNavigationBar.items = [JPNavigationItem]
        //导航条的渲染颜色
        JPNavigationBar.barTintColor = UIColor.hm_color(withHex: 0xF6F6F6)
        //设置 bar 的标题字体颜色
        JPNavigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.darkGray]
        //设置系统的UIBarbuttonItem的字体颜色
        JPNavigationBar.tintColor = UIColor.orange
    }
}

// MARK: - UITableViewDataSource,UITableViewDelegate
extension JPBaseViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    //基类负责准备方法 子类负责实现
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    //再显示最后一行时 执行上拉
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //计算row和section
        let row = indexPath.row
        let section = tableView.numberOfSections - 1
        
        if row < 0 || section < 0 {
            //如果不存在 直接return
            return
        }
        
        //当前组下的所有row的个数
        let count = tableView.numberOfRows(inSection: section)
        
        //判断条件
        if row == count - 1 && !isPullup {
            
            //执行上拉
            isPullup = true
            //获取数据
            loadData()
        }
        
        
    }
}

// MARK: - 注册 登录点击
extension JPBaseViewController {

    @objc fileprivate  func registerBtnClick() {
        print("注册")
    }
    
    @objc fileprivate func loginBtnClick() {
        //发送通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: JPUserShouldLoginNotification), object: nil)
    }
    
    @objc fileprivate func loginSuccess(){
        print("login  success")
        // 在访问view的getter时 如果View = nil 则会调用loadview --> Viewdidload 等于刷新界面
        view = nil
        // 避免通知被重复注册
        NotificationCenter.default.removeObserver(self)
    }
}
