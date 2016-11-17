//
//  UIBarbutton.swift
//  我的微博
//
//  Created by ming on 16/10/1.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit
extension UIBarButtonItem{
    //遍历构造函数类似于oc的分类
    convenience init(title:String,fontSize:CGFloat = 16,target: Any?,action: Selector ,isBack:Bool = false) {
        
        let butn:UIButton = UIButton.cz_textButton(title, fontSize: 16, normalColor: UIColor.black, highlightedColor: UIColor.orange);
        butn.addTarget(target, action:action, for: .touchUpInside)
        
        if isBack {
            let image = "navigationbar_back_withtext"
            let imageSelect = image + "_highlighted"
            //设置按钮的返回按钮的图片
            butn.setImage(UIImage(named:image) , for:.normal)
            butn.setImage(UIImage(named:imageSelect), for: .highlighted)
            //添加视图之后从新布局
            butn.sizeToFit()
        }
        self.init(customView: butn)
    }
    
    
    
}
