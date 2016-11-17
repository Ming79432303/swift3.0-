//
//  LGWeiboTool.swift
//  我的微博
//
//  Created by ming on 16/10/14.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

//微博底部工具栏
class LGWeiboTool: UIView {
///转发
   @IBOutlet weak var share: UIButton!
    ///评论
    @IBOutlet weak var comment: UIButton!
    ///点赞
    @IBOutlet weak var like: UIButton!
    var model:LGWeiBoStatus?{
        
        didSet{
            
           
            like.setTitle(model?.attitudes, for: .normal)
            share.setTitle(model?.reposts, for: .normal)
            comment.setTitle(model?.comments, for: .normal)
        }
    }
     
    
    
}
