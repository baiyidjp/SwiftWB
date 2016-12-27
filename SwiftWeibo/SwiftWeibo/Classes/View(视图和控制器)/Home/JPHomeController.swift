//
//  JPHomeController.swift
//  SwiftWeibo
//
//  Created by Keep丶Dream on 16/11/19.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD

private let originalCellId = "originalCellId"
private let retweetCellId = "retweetCellId"

class JPHomeController: JPBaseViewController {
    
    //懒加载 viewModel 
    fileprivate lazy var statusListViewModel = JPStatusListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //注册选中照片的通知
        NotificationCenter.default.addObserver(self, selector: #selector(selectedPicture), name: NSNotification.Name(rawValue: JPStatusPicturesSelectedNotification), object: nil)
    }
    
    deinit {
        //移除通知
        NotificationCenter.default.removeObserver(self)
    }
    
    
    //加载数据
    override func loadData() {
        
        refreshControl?.beginRefreshing()
        //MARK: -从 ViewModel 中加载数据
        self.statusListViewModel.loadStatusList(isPullup: self.isPullup) { (isSucces,isReloadData) in
            
            //不管上拉还是下拉 完成之后将判断条件改为false
            self.isPullup = false
            DispatchQueue.main.asyncAfter(wallDeadline: .now(), execute: {
                
                //结束刷新
                self.refreshControl?.endRefreshing()
            })
            
            if isSucces == true && isReloadData == true {
                self.tableView?.reloadData()
                //清楚item和APP的新信息数
                self.tabBarItem.badgeValue = nil
                UIApplication.shared.applicationIconBadgeNumber = 0
            }
        }
    }
    
    @objc fileprivate func showFriend() {
        
        let testVC = JPTestViewController()
        
        navigationController?.pushViewController(testVC, animated: true)
        
    }
    
    /// 点击图片的通知方法
    ///
    /// - Parameter notifation: 通知
    @objc fileprivate func selectedPicture(notifation:Notification) {
        
        guard let dict = notifation.userInfo,
            let selectedIndex = dict[JPStatusPicturesSelectedIndexKey] as? Int,
            let urls = dict[JPStatusPicturesSelectedUrlsKey] as? [String],
            let imageViews = dict[JPStatusPicturesSelectedImageViewsKey] as? [UIImageView]
        
            else {
                return
        }
        let photoController = JPPhotoBrowserController(selectedIndex: selectedIndex, urls: urls,imageViews: imageViews)
        //使用自定义转场 保留当前控制器
        photoController.modalPresentationStyle = .custom
        present(photoController, animated: true, completion: nil)
        
        
    }
    
}

//MARK: 数据表格方法
extension JPHomeController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return statusListViewModel.statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //取出模型数据
        let model = statusListViewModel.statusList[indexPath.row]
        //根据是否是转发微博 设置cellid
        let cellid = model.status.retweeted_status != nil ? retweetCellId : originalCellId
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! JPStatusCell
        
        //代理
        cell.retweetLabel?.delegate = self
        cell.statusLabel.delegate = self 
        //赋值
        cell.statusViewModel = model
        
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //取出模型数据
        let model = statusListViewModel.statusList[indexPath.row]
        
        return model.cellRowHeight
    }
}

//MARK: 设置界面
extension JPHomeController {
    
    //TODO: 重写父类方法  登录情况下设置表格
    override func setUpTableView() {
        
        super.setUpTableView()
        //设置导航栏 左边按钮
        JPNavigationItem.leftBarButtonItem = UIBarButtonItem(title: "好友", target: self, action: #selector(showFriend))
        
        //注册cell
        tableView?.register(UINib(nibName: "JPStatusNormalCell", bundle: nil), forCellReuseIdentifier: originalCellId)
        tableView?.register(UINib(nibName: "JPStatusRetweetedCell", bundle: nil), forCellReuseIdentifier: retweetCellId)
        tableView?.separatorStyle = .none
        //设置行高
//        tableView?.rowHeight = UITableViewAutomaticDimension
//        tableView?.estimatedRowHeight = 300
        setUpNavTitleView()
    }
    
    /// 这是主页的titleview
    fileprivate func setUpNavTitleView() {
        
        let myName = JPNetworkManager.sharedManager.userAccount.screen_name ?? ""
        let btn = JPHomeNavTitleBtn(title: myName)
        btn.addTarget(self, action: #selector(nameClicked), for: .touchUpInside)
        JPNavigationItem.titleView = btn
        
    }
    
    @objc fileprivate func nameClicked(btn: UIButton){
        
        btn.isSelected = !btn.isSelected
    }
}

// MARK: - JPAttributeLabelDelegate
extension JPHomeController : JPAttributeLabelDelegate {
    
    func labelDidSelectedLinkText(label: JPAttributeLabel, text: String) {
        
        if text.hasPrefix("http") {
        
            //跳转到一个webView
            let webVc = JPWebViewController()
            
            webVc.urlStr = text
            
            navigationController?.pushViewController(webVc, animated: true)
        }else if text.hasPrefix("@") {
            SVProgressHUD.showInfo(withStatus: "点击的是人名")
        }else if text.hasPrefix("#") {
            SVProgressHUD.showInfo(withStatus: "点击的是话题")
            
        }
        
        
    }
}
