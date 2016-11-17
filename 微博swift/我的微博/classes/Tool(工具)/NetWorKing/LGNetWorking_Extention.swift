//
//  LGNetWorking_Extention.swift
//  我的微博
//
//  Created by ming on 16/10/5.
//  Copyright © 2016年 ming. All rights reserved.
//

import Foundation


// MARK: - 类似于分类，处理请求并返回结果
extension LGNetWorkingManager{
    
    
    
    
    /// 返回好友微博数据
    ///
    /// - parameter since_id:   带此参数会返回比当前>id早的数据
    /// - parameter max_id:     带此参数会返回比当前<=id晚的数据所以后面要-1防止出现重复的微博
    /// - parameter complition: 返回结果回调
    func statusList(since_id:Int64 = 0 ,max_id:Int64 = 0,complition:@escaping (_ dataArray:[[String:AnyObject]] ,_ isSuccess:Bool) ->()) -> () {
//请求的地址
        let url = "https://api.weibo.com/2/statuses/friends_timeline.json"
        
        
        var parame = [String:String]()
        
       parame["since_id"] = "\(since_id)"

   //让max_id-1不会产生重复的数据
        parame["max_id"] = "\(max_id > 0 ? (max_id - 1) : 0)"
  //根据token请求的到数据回调
        takenRequest(method: .GET, URLString: url, parameters: parame) { (json, isSuccess) in
         
      
            guard  let j = json,
                let dataArray = j["statuses"] as? [[String:AnyObject]] else{
                  
                return
            }
            //请求成数据成功回调
            complition(dataArray, isSuccess)
        }
   
    }
    
    /// 请求得出未读消息数据
    ///
    /// - parameter complition: uid 微博的uid
    func  unreadCount(complition:@escaping (_ cont:Int)->()){
        
        let uidUrl = "https://rm.api.weibo.com/2/remind/unread_count.json"
        guard let uid = userAccess.uid else {
            return
        }
        
        let parame = ["uid":uid]
        ///token请求默认为get请求
        takenRequest(URLString: uidUrl, parameters: parame) { (json, isSueecss) in

            guard let dict = json  as? [String:AnyObject] else{
                
                return
            }
            
            
            let count = dict["status"] as! Int
            complition(count)
            
        }
        
    }
    
    
}



// MARK: - 请求授权码
extension LGNetWorkingManager{
    
//    https://api.weibo.com/oauth2/access_token
    
    func loadAccessToken(conde:String ,complietion:@escaping (_ isSuccess:Bool) ->()){
      
    
        let url = "https://api.weibo.com/oauth2/access_token"
        let parameters = ["client_id":client,
                          "client_secret":secret,
                          "grant_type":"authorization_code",
                          "code":conde,
                          "redirect_uri":rectUri]
        request(method: .POST, URLString: url, parameters: parameters) { (json, isSuccess) in
      //字典专模型
      
            let dict = json as? [String:AnyObject] ?? [:]
            //字典专模型
            self.userAccess.yy_modelSet(with: dict)
                       //获取用户信息
        
          

                         self.loadUserInfo(complietion: { (dict, isSuccess) in
              
                         //            保存用户数据模型到json中
            self.userAccess.saveAccessToken()

              //FXMi:
                            //执行闭包AccessToken结果回调,跳转控制器
                            complietion(isSuccess)
            })
            
           
        }
        
    }
  
}
extension LGNetWorkingManager{
    
    //处理获取信息成功回调
    func  loadUserInfo(complietion:@escaping (_ dict:[String:AnyObject]?,_ isSuccess:Bool)->()){
 
    guard let uid = userAccess.uid,
    let token = userAccess.access_token else {
        return
    }
  let url = "https://api.weibo.com/2/users/show.json"
    let parameters = ["access_token":token,
    "uid":uid] as [String:String]
    
    takenRequest(URLString: url, parameters: parameters) { (json, isSuccuss) in
        

    
        let dict = json as? [String:AnyObject] ?? [:]
        self.userAccess.yy_modelSet(with: dict)
        //执行回调
        complietion(dict, true)
        
    }
    }
    
    
}

//发送微博//上传图片并发布一条新微博 POST是否    func
extension LGNetWorkingManager{
    
    func upload(text:String, image: UIImage?, completion: @escaping (_ status:[String:AnyObject]?, _ isSuccess:Bool)->()){
        
        // 1. url
        let url: String
      
        
        let parameters = ["status":text]
        
        var name: String?
        var data: Data?
        if let image = image {
          url = "https://upload.api.weibo.com/2/statuses/upload.json"
             name = "pic";
             data = UIImagePNGRepresentation(image)
        }else{
             url = "https://api.weibo.com/2/statuses/update.json"
        }
        takenRequest(method: .POST, URLString: url, parameters: parameters, name: name, data: data) { (json, isSuccess) in
            
            completion(json as? [String : AnyObject], isSuccess)
        }

        
        
    }
    
    
}



