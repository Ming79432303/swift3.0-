//
//  LGWebcontrollwer.swift
//  我的微博
//
//  Created by ming on 16/10/22.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

class LGWebcontrollwer: LGBasiViewController  {
  lazy var webview = UIWebView(frame: UIScreen.main.bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func setTableView() {
        view.insertSubview(webview, belowSubview: navBar)
        self.webview.scrollView.contentInset.top = 64
        self.title = "网页"
    }



}
