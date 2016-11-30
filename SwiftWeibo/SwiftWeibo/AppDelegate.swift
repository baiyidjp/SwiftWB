//
//  AppDelegate.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/11/18.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import UIKit
import UserNotifications
import SVProgressHUD
import AFNetworking

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // 设置程序的额外信息
        setAdditions()
        
        window = UIWindow()
        window?.rootViewController = JPMainViewController()
        window?.makeKeyAndVisible()
        
        loadAppinfo()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

// MARK: - 模拟异步加载数据并保存在本地
extension AppDelegate {
    
    fileprivate func loadAppinfo() {
        
        let url = Bundle.main.url(forResource: "weibomain.json", withExtension: nil)
        let data = NSData(contentsOf: url!)
        data?.write(toFile: weiboMainPath!, atomically: true)
        print(weiboMainPath ?? "")
    }
    
}

// MARK: - 设置额外信息
extension AppDelegate {
    
    fileprivate func setAdditions() {
        
        //设置最小的显示时间
//        SVProgressHUD.setMinimumDismissTimeInterval(1)
        //显示网络加载提示
        AFNetworkActivityIndicatorManager.shared().isEnabled = true
        
        /// 请求用户同意发送通知
        /// 判断设备的版本号 10.0及以上使用这个方法
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound,.carPlay]) { (success, error) in
                print("授权接收通知" + (success ? "成功": "失败"))
            }
        } else {
            // 10.0以下使用这个方法
            let notificationSet = UIUserNotificationSettings(types: [.alert,.badge,.sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(notificationSet)
        }

    }

}
