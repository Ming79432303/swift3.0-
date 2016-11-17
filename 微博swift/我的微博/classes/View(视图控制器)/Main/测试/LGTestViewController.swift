//
//  LGTestViewController.swift
//  我的微博
//
//  Created by ming on 16/10/1.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

class LGTestViewController: LGBasiViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        title = "第\(navigationController?.childViewControllers.count ?? 0)个"

        // Do any additional setup after loading the view.
    }
  func nextVc(){
        
        navigationController?.pushViewController(LGTestViewController(), animated: true)
        
    }
   
}
extension LGTestViewController{
    
    override func setUI() {
        super.setUI()
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "下一个", style: .plain, target: self, action: #selector(nextVc))
        
       
        
        navItem.rightBarButtonItem = UIBarButtonItem(title: "下一个", target: self, action: #selector(nextVc))
    }
    
}
