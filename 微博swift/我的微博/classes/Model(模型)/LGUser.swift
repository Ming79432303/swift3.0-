//
//  LGUser.swift
//  我的微博
//
//  Created by ming on 16/10/13.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

/// 用户模型
class LGUser: NSObject {
    //基本数据类型&private不能使用KVC
    var id: Int64 = 0
    ///用户昵称
    var screen_name: String?
    ///用户头像中图50*50
    var profile_image_url: String?
    ///认证类型,-1:没有认证，0，认证用户，2，3，4，5：企业认证，220达人
    var verified_type: Int = 0
    ///会员等级 0 - 6
    var mbrank: Int = 0
    override var description: String{
        
        return yy_modelDescription()
    }
}
