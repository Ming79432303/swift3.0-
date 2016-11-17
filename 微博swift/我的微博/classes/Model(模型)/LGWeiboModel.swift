//
//  LGWeiboModel.swift
//  我的微博
//
//  Created by ming on 16/10/6.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit
import YYModel
//微博数据类型
class LGWeiboModel: NSObject {
    
    
    var id:Int64 = 0
    var text:String?
    var user:LGUser?
    var reposts_count: Int = 0
    var comments_count: Int = 0
    var attitudes_count: Int = 0
    var pic_urls: [LGWeiBoPicModel]?
    var retweeted_status:LGWeiboModel?
    
    
    /// 微博创建时间字符串
    var created_at: String? {
        didSet {
            createdDate = Date.cz_sinaDate(string: created_at ?? "")
        }
    }
    
    /// 微博创建日期
    var createdDate: Date?
    

    
    var source: String?{
        didSet{
            
            
            source = source?.cz_href()?.text ?? ""
        }
        
    }
    
   

    class func modelContainerPropertyGenericClass()->[String:AnyObject]{
    
    return ["pic_urls" : LGWeiBoPicModel.self]
    
    }
    
    
    override var description: String{
        
    
        return yy_modelDescription()
    }
}
