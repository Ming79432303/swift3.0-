//
//  LGUserAccess.swift
//  我的微博
//
//  Created by ming on 16/10/7.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit
//保存的文件名称
private let accessFileName:NSString = "token.json"
class LGUserAccess: NSObject {
    var access_token:String?
    var expires_in:TimeInterval = 0{
        didSet{
            expiresDate = Date(timeIntervalSinceNow: expires_in)
            
        }
        
    }
    var uid:String?
    var expiresDate:Date?
    
//    "avatar_large" = "http://tva3.sinaimg.cn/crop.0.0.512.512.180/73f0935fjw8er5e923xlpj20e80e8t9c.jpg";
//    name = "\U5915\U9633Lgming";
    //用户头像
    var avatar_large:String?
    //用户昵称
    var name:String?
    
    
    override var description: String{
        
        return yy_modelDescription()
    }
    
    //构造函数，执行（）就会执行这个方法
    override init() {
        super.init()
        //读取磁盘数据
     guard  let path = accessFileName.cz_appendDocumentDir(),
       let data = NSData(contentsOfFile: path),
        let json = try? JSONSerialization.jsonObject(with: data as Data, options: []) else{
            
            return
        }
        //把字典的值设置给账户模型
        yy_modelSet(with: json as! [String:AnyObject])
        //根据秒来生成一个过期时间
        //expiresDate = Date(timeIntervalSinceNow: -3600 * 24)
        //账户的有效期处理expiresDate//如果不是倒序,倒序是最早的在上边
        if  expiresDate?.compare(Date()) != .orderedDescending {
            print("账户过期")
            //清除数据
            uid = nil
            access_token = nil
            expiresDate = nil
            //删除文件
           _ = try? FileManager.default.removeItem(atPath: accessFileName.cz_appendDocumentDir())
        }
        
        print("账户正常")
        
        
        
        
    }
    
    
    //保存用户的token
    func saveAccessToken(){

        //模型数组转字典
        var json = self.yy_modelToJSONObject() as? [String:AnyObject] ?? [:]
        json.removeValue(forKey: "expires_in")
        //字典转json(data数据)
  guard  let data = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted]) as NSData,
        //存入的路径
    let path =  accessFileName.cz_appendDocumentDir() else{
        
            return
        }
       print(path)
        //写入磁盘
        data.write(toFile: path, atomically: true)
        print(path)
    }
    

}
