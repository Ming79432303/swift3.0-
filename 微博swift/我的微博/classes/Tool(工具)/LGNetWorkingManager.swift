//
//  LGNetWorkingManager.swift
//  我的微博
//
//  Created by ming on 16/10/5.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit
import AFNetworking


//定义请求方法枚举
enum LGHttpMethod {
    case GET
    case POST
 }

/// 请求工具类，封装AFN
class LGNetWorkingManager: AFHTTPSessionManager {
    
    //懒加载授权成功账户模型数据模型数据
    lazy var userAccess = LGUserAccess()

    
    //给用户添加一个是否登录的标记
    var  userShouldLogon:Bool{
  
        return userAccess.access_token != nil
    }
    
    //创建一个单列，继承AFN隔离第三方框架,这个闭包模式
    static let shared:LGNetWorkingManager = {
        
        // 实例化对象
        let instance = LGNetWorkingManager()
        
        // 设置响应反序列化支持的数据类型
        instance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        // 返回对象
        return instance
    }()

    
    /// taken请求，因为每次请求都依赖于token所以我们需要封装一个taken请求
    ///
    /// - parameter method:     请求的方法
    /// - parameter URLString:  请求的地址
    /// - parameter parameters: 请求的参数
    /// - parameter completion: 请求结果回调
    func takenRequest(method:LGHttpMethod = .GET,URLString:String ,parameters:[String:String]? ,name:String? = nil, data:Data? = nil, completion:@escaping (_ json: AnyObject? ,_ isSuccess: Bool) -> ()){
        //形参不可更改所以需要一个参数接收下来更该
        var parameters = parameters
        //判断是否带有token
        guard let taken = userAccess.access_token else {
            //  发送通知
            print("没有token请登录")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: LGwbUserShoulLoginNotification), object: nil)
            //回调结果
            completion(nil, false)
            return
        }
        //判断数组是否为空
        if parameters == nil {
            parameters = [String:String]()
        }
        //parameters一定有值，给参数加入一个token，只要有token的请求，调用这个方法以后的链接就不必要在添加token了
        parameters!["access_token"] = taken
        
        if let name = name ,
            let data = data {
            //用作文件上传
            upload(urlString: URLString, parameters: parameters, name: name, data: data, completion: completion)
        }else{
            //带token的参数请求
            request(method: method, URLString: URLString, parameters: parameters, completion: completion)
        }
  
    }
    //
    /// 上传文件的AFN方法
    ///
    /// - parameter urlString:  上传文件的借口
    /// - parameter parameters: 上传的参数
    /// - parameter name:       上传图片对于接口的字段
    /// - parameter data:       上传图片的二进制数据
    /// - parameter completion: 完成回调
    func upload(urlString:String, parameters:[String:String]?, name:String, data:Data, completion:@escaping (_ json:AnyObject?, _ isSuccess:Bool) ->()){
        
        post(urlString, parameters: parameters, constructingBodyWith: { (fromData) in
          //追加数据
            
            // 创建 formData
            /**
             1. data: 要上传的二进制数据
             2. name: 服务器接收数据的字段名
             3. fileName: 保存在服务器的文件名，大多数服务器，现在可以乱写
             很多服务器，上传图片完成后，会生成缩略图，中图，大图...
             4. mimeType: 告诉服务器上传文件的类型，如果不想告诉，可以使用 application/octet-stream
             image/png image/jpg image/gif
             */
            
            fromData.appendPart(withFileData: data, name: name, fileName: "", mimeType: "application/octet-stream")
            
            
            
            
            }, progress: nil, success: { (task, json) in
                //成功回调
                let j = json as AnyObject?
                completion(j, true)
                
            }) { (task, error) in
                //失败回调
                //处理请求过期
                if (task?.response as? HTTPURLResponse)?.statusCode == 403{
                    
                    print("请求过期")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: LGwbUserShoulLoginNotification), object: "token is bad")
                }
                //回调过期结果

                
                completion(nil, false)
        }
       
       
    }
 
    
    
    
    //
    /// 用一个函数封装AFN网络工具
    ///
    /// - parameter method:     确定请求方法
    /// - parameter URLString:  请求的Url地址
    /// - parameter parameters: 请求的参数
    /// - parameter completion: 处理结果的回调闭包
    func request(method:LGHttpMethod = .GET,URLString:String ,parameters:[String:String]?,completion:@escaping (_ json: AnyObject? ,_ isSuccess: Bool) -> ()){
       
        
        //成功回调，用于AFN成功回调的方法
        let success = { (task:URLSessionDataTask,json:Any?)  -> () in
            //回调json处理成功结果
            completion((json! as AnyObject), true)
            
        }
        //失败闭包回调，用于接收afn失败回调的方法
        let failure = {(task:URLSessionDataTask?,error:Error) -> () in
        
            //处理请求过期
           if (task?.response as? HTTPURLResponse)?.statusCode == 403{
            
            print("请求过期")
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: LGwbUserShoulLoginNotification), object: "token is bad")
            }
            //回调过期结果
             completion(nil,false)
        }
        
        if method == .GET {
             //AFN的post方法的get方法
            get(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }else{
            
            
            //AFN的post方法
            post(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
            
        }

        
        
    }
    
    
    
    
}






