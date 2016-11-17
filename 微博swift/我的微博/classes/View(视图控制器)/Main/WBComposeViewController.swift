//
//  WBComposeViewController.swift
//  我的微博
//
//  Created by ming on 16/10/20.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit
import SVProgressHUD

class WBComposeViewController: UIViewController {

    @IBOutlet weak var bottomOffset: NSLayoutConstraint!
    @IBOutlet var userLabel: UILabel!
    
    @IBOutlet weak var tooBar: UIToolbar!
    
    @IBOutlet weak var textView: LGTextView!
    
    /// 表情输入视图
    lazy var emoticonView: CZEmoticonInputView = CZEmoticonInputView.inputView { [weak self] (emoticon) in
        
        self?.textView.insertEmoticon(em: emoticon)
    }

    
    lazy var sendBtton = UIButton(type: .custom)
    override func viewDidLoad() {
        super.viewDidLoad()
     
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", target: self, action: #selector(close))
        textView.contentInset.top = 64
        //添加监听
        
   
        
        setUI()
    }
    
     func close(){
        
        view.endEditing(true)
    
        dismiss(animated: true, completion: nil)
    
    }
    
    
}


extension WBComposeViewController{
    
    func setUI(){
        setNavagationBar()
        setToolBar()
        self.textView.delegate = self
        textView.becomeFirstResponder()
        
    }
    @objc private func sendWeibo(){
     // 1. 获取发送给服务器的表情微博文字
        let statusText = textView.emoticonText
        let imaga:UIImage? = nil//UIImage(named: "icon_small_kangaroo_loading_1")
        LGNetWorkingManager.shared.upload(text: statusText, image: imaga){ (dicr, isSuccess) in
            
            SVProgressHUD.setDefaultStyle(.dark)
            if isSuccess{
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: { 
                    
                    SVProgressHUD.showInfo(withStatus: "发送成功")
                    self.close()
                })
                
            }else{
                SVProgressHUD.showInfo(withStatus: "发送失败")
            }
        }
    
    }
    //设置发送按钮
    func setNavagationBar(){
        
  
        
        sendBtton.setTitle("发送", for: .normal)
        sendBtton.setTitleColor(UIColor.white, for: .normal)
        sendBtton.setTitleColor(UIColor.darkGray, for: .disabled)
            sendBtton.setBackgroundImage(UIImage(named:"common_button_white_disable"), for: .disabled)
        
        sendBtton.setBackgroundImage(UIImage(named:"common_button_orange"), for: .normal)
        sendBtton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        sendBtton.frame = CGRect(x: 0, y: 0, width: 45, height: 35)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sendBtton)
        self.navigationItem.titleView = userLabel
        sendBtton.addTarget(self, action: #selector(sendWeibo), for: .touchUpInside)
 
    }
           //添加键盘
    func emoticonKeyboard(){
        //添加键盘

        // 2> 设置键盘视图
        textView.inputView = (textView.inputView == nil) ? emoticonView : nil
        textView.reloadInputViews()
        
        
    }
    
    

    
    //设置工具栏
 func  setToolBar(){
    
    
        let itemSettings = [["imageName": "compose_toolbar_picture"],
                        ["imageName": "compose_mentionbutton_background"],
                        ["imageName": "compose_trendbutton_background"],
                        ["imageName": "compose_emoticonbutton_background", "actionName": "emoticonKeyboard"],
                        ["imageName": "compose_add_background"]]
//    compose_toolbar_picture_highlighted
    
    var buttons = [UIBarButtonItem]()
    for dict in itemSettings {
        
        let toolButn = UIButton(type: .custom)
       guard let image = dict["imageName"]
         else {
            
            return
        }
        //添加监听事件
        if let emoticonKeyboard = dict["actionName"] {
            
            toolButn.addTarget(self, action: Selector(emoticonKeyboard), for: .touchUpInside)
        }
        
        
        let iamgeSelect = image + "_highlighted"
        toolButn.setImage(UIImage(named:image), for: .normal)
        toolButn.setImage(UIImage(named:iamgeSelect), for: .highlighted)
        toolButn.sizeToFit()
        //添加弹簧
        let t = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        buttons.append(t)
        
        buttons.append(UIBarButtonItem(customView: toolButn))
    }
        buttons.removeFirst()
        tooBar.items = buttons
    //键盘处理方法
    //添加键盘监听方法
    NotificationCenter.default.addObserver(self, selector: #selector(textChange), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    
    
    }
    @objc private func textChange(info:Notification){
        guard   let keyboradframe = info.userInfo?[UIKeyboardFrameEndUserInfoKey] ,
        let duration = info.userInfo?[UIKeyboardAnimationDurationUserInfoKey] else {
            
            return
        }
        let kbframe = keyboradframe as! NSValue
        let k = kbframe.cgRectValue
        
        let offsety = self.view.bounds.height - k.origin.y
      let d =  duration as! TimeInterval
          self.bottomOffset.constant = offsety
        UIView.animate(withDuration: d) {
           
             self.view.layoutIfNeeded()
            
        }
       
  
       
    }
    
    
}






//代理方法
extension WBComposeViewController: UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        sendBtton.isEnabled = textView.hasText
    }
  
    func textViewDidBeginEditing(_ textView: UITextView) {
        
         sendBtton.isEnabled = textView.hasText
    }
    
    
}




