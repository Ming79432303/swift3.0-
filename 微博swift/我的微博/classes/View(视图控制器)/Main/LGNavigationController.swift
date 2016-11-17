//
//  LGNavigationController.swift
//  我的微博
//
//  Created by ming on 16/10/1.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

class LGNavigationController: UINavigationController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
      

        
        
    }
    func popBack(){

      popViewController(animated: true)
        
    }

    
        //从写push方法
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
   
        //如果是栈顶控制器就不隐藏
        if  childViewControllers.count > 0{
            //隐藏底部条
         viewController.hidesBottomBarWhenPushed = true
            
            //给非栈顶添加返回按钮
            if let vc = viewController as? LGBasiViewController {
                
                //设置第一个子控制器的标题,就是父控制器的标题
                if childViewControllers.count == 1 {
                    vc.navItem.leftBarButtonItem = UIBarButtonItem(title:navigationItem.title ?? "返回", target: self, action: #selector(popBack), isBack:true)
                }else{
              //设置返回按钮
              vc.navItem.leftBarButtonItem = UIBarButtonItem(title: "返回", target: self, action: #selector(popBack), isBack:true)
                }
            }
            
            
        }
       
        super.pushViewController(viewController, animated: animated)
        
        
    }
}


