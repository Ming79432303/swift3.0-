//
//  AppDelegate.swift
//  我的微博
//
//  Created by ming on 16/10/1.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit
import UserNotifications
import AFNetworking
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        
        window = UIWindow()
        window?.rootViewController = LGTabBarController()
        window?.backgroundColor = UIColor.red
        
        window?.makeKeyAndVisible()
        jsonForUrl()
        return true
    }
}
//添加额外设置
extension AppDelegate{
    
    func additions(){
        
        SVProgressHUD.setMinimumDismissTimeInterval(1.0)
        AFNetworkActivityIndicatorManager.shared().isEnabled = true
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound,.carPlay]) { (isSuccess, eorror) in
                //  print("授权" + (isSuccess ? "成功":"失败"))
            }
        } else {
            // 10.0以下
            let settings = UIUserNotificationSettings(types: [.alert,.badge,.sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
        

    }
    
    
    
}

//网络请求加载数据
extension AppDelegate{
    
    func jsonForUrl(){
        //开启子线程读取服务器中的数据
        DispatchQueue.global().async {
            //从网络下载数据
            let dictJson =  URL(string: "http://q.wap52.cn/dict.json")
            let data =  NSData(contentsOf: dictJson!)
            
            //写入到磁盘
            //取0就不需要确定是否可选
            let path =  NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
            
            let pathName =  path.appendingPathComponent("json.json")
            
            data?.write(toFile: pathName, atomically: true)
        }
        
        
        
    }
    

    
}





