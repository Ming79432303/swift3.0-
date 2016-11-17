//
//  LGCoposeTypeButn.swift
//  我的微博
//
//  Created by ming on 16/10/19.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

class LGCoposeTypeButn: UIControl {
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var clsName:String?

    
   
   class func composeTypeButton(imageName: String, title: String) -> LGCoposeTypeButn  {
    
        let nib = UINib(nibName: "LGCoposeTypeButn", bundle: nil)
    
        let btn = nib.instantiate(withOwner: nil, options: nil)[0] as! LGCoposeTypeButn
    
        btn.titleLable.text = title
        btn.imageView.image = UIImage(named: imageName)
    
        return btn
    
    }
    
//    /// 使用图像名称／标题创建按钮，按钮布局从 XIB 加载
//    class func composeTypeButton(imageName: String, title: String) -> LGCoposeTypeButn {
//        
//        let nib = UINib(nibName: "WBComposeTypeButton", bundle: nil)
//        
//        let btn = nib.instantiate(withOwner: nil, options: nil)[0] as! LGCoposeTypeButn
//        
//        btn.imageView.image = UIImage(named: imageName)
//        btn.titleLable.text = title
//        
//        return btn
//    }
    //

//
    
}
