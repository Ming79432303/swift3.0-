//
//  LGAuthController.swift
//  我的微博
//
//  Created by ming on 16/10/7.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit
import SVProgressHUD
class LGAuthController: UIViewController {
  lazy var webView = UIWebView()
    override func loadView() {
        
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //设置webView
        setWebView()
        
    }

   
private func setWebView(){
    
        webView.scrollView.isScrollEnabled = true
        title = "登录微博"
        webView.delegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "首页", fontSize: 14, target: self, action: #selector(back), isBack: true)
        //请求网址
        guard  let url = URL(string: "https://api.weibo.com/oauth2/authorize?client_id=\(client)&redirect_uri=\(rectUri)")
            else{
                
                
                return
        }
        //请求
        let request = URLRequest(url: url)
        //加载请求
        webView.loadRequest(request)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", target: self, action:#selector(autoFill))

    }
    
    //返回控制器
   func back(){
        SVProgressHUD.dismiss()
      dismiss(animated: true, completion: nil)
    }
 @objc  func autoFill(){
        
        
    //调用javaScript
    let javaScript = "document.getElementById('userId').value='15677283050';" + " document.getElementById('passwd').value='m1579116334';"
    //自动注入
    webView.stringByEvaluatingJavaScript(from: javaScript)

    }
    
}
//webdelegate
extension LGAuthController:UIWebViewDelegate{
    
    
    //开始加载的时候调用这个方法
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        //获取链接字符串
        let url = request.url?.absoluteString
        //判断是否包含uri不包含就不在加载
        if url?.hasPrefix(rectUri) == false{
            return true
        }
        let code = request.url?.query
        //判断是否包含返回的token
        if code?.hasPrefix("code=") == false {
            
            back()
            return false
        }
        //截取字符串得到授权码
        let auth = code?.substring(from: "code=".endIndex) ?? ""
        
        
        LGNetWorkingManager.shared.loadAccessToken(conde: auth) { (isSussce) in
            //通知控制器登录
            SVProgressHUD.showInfo(withStatus: "授权成功")
           
            //发送通知，切换控制器
           NotificationCenter.default.post(name: NSNotification.Name(rawValue: userLoginNotification), object: nil)
           
            self.back()
        }
        
        return false
    }
    //开始的时候调用这个方法
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    //加载结束的时候调用这个方法
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    
}





