
//
//  JPWeiboCommon.swift
//  SwiftWeibo
//
//  Created by tztddong on 2016/11/24.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

import Foundation


//MARK: 常量
// 屏幕的宽/高
let ScreenWidth = UIScreen.main.bounds.width
let ScreenHeight = UIScreen.main.bounds.height

//MARK: 全部可以使用
/// 用户需要登录的通知名
let JPUserShouldLoginNotification = "JPUserShouldLoginNotification"
/// 用户登陆成功的通知名
let JPUserLoginSuccessNotification = "JPUserLoginSuccessNotification"
/// 选中照片的通知名
let JPStatusPicturesSelectedNotification = "JPSelectedImageNotification"
/// 选中的照片的index key值
let JPStatusPicturesSelectedIndexKey = "JPStatusPicturesSelectedIndexKey"
/// 所有照片的Url数组的 key值
let JPStatusPicturesSelectedUrlsKey = "JPStatusPicturesSelectedUrlsKey"
/// 所有可视的ImageView key值
let JPStatusPicturesSelectedImageViewsKey = "JPStatusPicturesSelectedImageViewsKey"

//MARK: 授权需要信息
//应用的ID
let SinaClient_id     = "134772235"
//回调地址--登录完成跳转的url
let SinaRedirect_uri  = "https://www.baidu.com"
//加密信息--开发者可以申请修改
let SinaAppSecret     = "016c705fab21e8f51447e9fd808e7c91"

//MARK: 文档存储地址
//授权信息地址
let userAccountPath: String? = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last?.appending("/userAccount.json")
//访客信息地址
let weiboMainPath: String? = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last?.appending("/weibomain.json")
//当前版本号保存地址
let currentVersionPath: String? = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last?.appending("/currentVersionPath")

//MARK: 微博配图
//外围距离
let JPStatusPicOutterMargin = CGFloat(12)
//内部间距
let JPStatusPicIntterMargin = CGFloat(3)
//配图view的宽度
let JPStatusPictureViewWidth = ScreenWidth - 2 * JPStatusPicOutterMargin
//单张图片的宽度/高度
let JPStatusPictureWidth = JPStatusPictureViewWidth / 3
