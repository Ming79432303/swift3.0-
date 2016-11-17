//
//  common_extensitions.swift
//  我的微博
//
//  Created by ming on 16/10/7.
//  Copyright © 2016年 ming. All rights reserved.
//

import Foundation
let LGwbUserShoulLoginNotification = "LGwbUserShoulLoginNotification"
let userLoginNotification = "userLoginNotification"
//App Key：800817303
let  secret = "37af1178bb1f21ae62d7a566f685a6fb"

let client:String = "800817303"
let rectUri = "http://52it.me"

let WeiBoStatusPicOuterMargin = CGFloat(12)
let WeiBoinnerMargin = CGFloat(3)
//视图的宽度
let WeiBoPicWidth = UIScreen.cz_screenWidth() - 2 * WeiBoStatusPicOuterMargin
//计算出每个图片的宽度
let WeiBoPicItemWidth = (WeiBoPicWidth - WeiBoinnerMargin * 2) / 3

/// 微博 Cell 浏览照片通知
let WBStatusCellBrowserPhotoNotification = "WBStatusCellBrowserPhotoNotification"
/// 选中索引 Key
let WBStatusCellBrowserPhotoSelectedIndexKey = "WBStatusCellBrowserPhotoSelectedIndexKey"
/// 浏览照片 URL 字符串 Key
let WBStatusCellBrowserPhotoURLsKey = "WBStatusCellBrowserPhotoURLsKey"
/// 父视图的图像视图数组 Key
let WBStatusCellBrowserPhotoImageViewsKey = "WBStatusCellBrowserPhotoImageViewsKey"
