//
//  WBStatusListDAL.swift
//  我的微博
//
//  Created by ming on 16/10/25.
//  Copyright © 2016年 ming. All rights reserved.
//

import Foundation
///负者处理数据库和网络数据
class WBStatusListDAL{
    ///负者处理数据库和网络数据
    class func statusListDAL(since_id: Int64, max_id: Int64,completion:@escaping (_ json:[[String:AnyObject]],_ isSuccess:Bool)->()) {
        //将数据写入数据库
        guard let uid = LGNetWorkingManager.shared.userAccess.uid else{
            
            return
        }

        //检查本地数据库是否有缓存，如果有，直接返回
     let array = LGSQLlieManager.shared.loadStatus(userid: uid, since_id: since_id, max_id: max_id)
        if array.count != 0 {
            return
        }
        //如果本地没有数据那么就请求网络数据
       LGNetWorkingManager.shared.statusList(since_id: since_id, max_id: max_id) { (json, isSuccess) in
        
        //如果请求数据不成功
        if !isSuccess{
          
            completion(json, false)
            return
        }
        
                 //将网络数据写入到数据库
        LGSQLlieManager.shared.updateStatus(userid: uid, array: json)

        //返回数网络数据
        completion(json, isSuccess)
        
        
        }

    
    }
    
}
