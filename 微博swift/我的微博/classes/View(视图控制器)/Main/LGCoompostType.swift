//
//  LGCoompostType.swift
//  我的微博
//
//  Created by ming on 16/10/19.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit
import pop

class LGCoompostType: UIView {

    @IBOutlet weak var closeCons: NSLayoutConstraint!
    @IBOutlet weak var backcons: NSLayoutConstraint!
    @IBOutlet weak var coposeType: UIScrollView!
    @IBOutlet weak var backButn: UIButton!
    
    private var completionBlock:((_ clsName:String?)->())?
    
    
    /// 按钮数据数组
    private let buttonsInfo = [["imageName": "tabbar_compose_idea", "title": "文字", "clsName": "WBComposeViewController"],
                               ["imageName": "tabbar_compose_photo", "title": "照片/视频"],
                               ["imageName": "tabbar_compose_weibo", "title": "长微博"],
                               ["imageName": "tabbar_compose_lbs", "title": "签到"],
                               ["imageName": "tabbar_compose_review", "title": "点评"],
                               ["imageName": "tabbar_compose_more", "title": "更多", "actionName": "clickMore"],
                               ["imageName": "tabbar_compose_friend", "title": "好友圈"],
                               ["imageName": "tabbar_compose_wbcamera", "title": "微博相机"],
                               ["imageName": "tabbar_compose_music", "title": "音乐"],
                               ["imageName": "tabbar_compose_shooting", "title": "拍摄"]
    ]

    
    class func compostTypeView()->(LGCoompostType){
    let nib = UINib(nibName: "LGCoompostType", bundle: nil)
       
      
        let cView = nib.instantiate(withOwner: nil, options: nil)[0]
       
          let v = cView as! (LGCoompostType)

        v.frame = UIScreen.main.bounds
         //解决出现600问题
          v.setupUI()
        return v
        
    }
    
    //显示界面
    func show(complition:@escaping (_ clsName:String?)->()){
        
        
        guard let vc = UIApplication.shared.keyWindow?.rootViewController?.view else{
            
            return
        }
        completionBlock = complition
        vc.addSubview(self)
      
          //开始动画
         animati()

        
    }
    
    func setupUI(){
         //强制跟新frame。
        layoutIfNeeded()
        let size = coposeType.bounds
        for i in 0..<2 {
            let v = UIView(frame: size)
            v.frame = coposeType.bounds.offsetBy(dx: CGFloat(i) * size.width, dy: 0)
            
            addButton(v: v, idx: i * 6)
            coposeType.addSubview(v)
        }
        coposeType.contentSize = CGSize(width: 2 * UIScreen.main.bounds.width, height: 0)
        coposeType.showsHorizontalScrollIndicator = false
        coposeType.showsVerticalScrollIndicator = false

        coposeType.isScrollEnabled = false
        
        
        
       
    }
    
    //向v中添加按钮，按钮的数组是从ide开始的
    func addButton(v:UIView,idx:Int){
        //添加按钮
        let count = 6
        
        for i in idx..<(idx + count) {
            
            if i >= buttonsInfo.count{
                break
            }
            
        let dict = buttonsInfo[i]
     guard   let imageName = dict["imageName"],
        let title = dict["title"] else{
                continue
            }
            //创建按钮
          let btn = LGCoposeTypeButn.composeTypeButton(imageName: imageName, title: title)
         
            //把按钮添加到视图中
        v.addSubview(btn)
           //添加单击
            if let clickMore = dict["actionName"] {
                
                btn.addTarget(self, action: Selector(clickMore), for: .touchUpInside)
            }else{
                
                btn.clsName = dict["clsName"]
                btn.addTarget(self, action: #selector(clickButn), for: .touchUpInside)
            }
            
        
        }
        //计算frame
    
        let btnSize = CGSize(width: 100, height: 100)
        let margin = (v.bounds.width - 3 * btnSize.width) / 4
        
        for (i, btn) in v.subviews.enumerated() {
            
            let y: CGFloat = (i > 2) ? (v.bounds.height - btnSize.height) : 0
            let col = i % 3
            let x = CGFloat(col + 1) * margin + CGFloat(col) * btnSize.width
            
            btn.frame = CGRect(x: x, y: y, width: btnSize.width, height: btnSize.height)
     
        }
        
        
        
        
    }
@objc private  func clickMore(){
        
        
        coposeType.setContentOffset(CGPoint(x:coposeType.bounds.width,y:0), animated: true)
        backButn.isHidden = false
        let margin = coposeType.bounds.width/6
        backcons.constant = -margin
        closeCons.constant = margin
        UIView.animate(withDuration: 0.25) {
            self.backButn.alpha = 1
            self.layoutIfNeeded()
        }

        
        
    }
    
    //店家切换控制器
@objc private func clickButn(Button:LGCoposeTypeButn){
        
        print("点击我了");
    //先判断是那一页
    let page = Int(coposeType.contentOffset.x/coposeType.bounds.width)
    
    let v = coposeType.subviews[page]
    
    for (i,butn) in v.subviews.enumerated() {
        
        //遍历出按钮
        //创建缩放动
        let animati = POPBasicAnimation(propertyNamed: kPOPViewScaleXY)
        
        let scale = Button == butn ? 1.5 : 0.5
        let value = NSValue(cgPoint: CGPoint(x: scale, y: scale))
       
        animati?.toValue = value
        
        animati?.duration = 1
        
        butn.pop_add(animati, forKey: nil)
        //渐变动画
        let alphAnimati:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        
        alphAnimati.fromValue = 0.5
        alphAnimati.toValue = 0
        
        butn.pop_add(alphAnimati, forKey: nil)
        //动画完成切换控制器
        if i == 0 {
            
            alphAnimati.completionBlock = { _,_ in
                
                    self.completionBlock?(Button.clsName)
            }
            
        }
        

        
    }
    
    
    
    
    
    }
    
    
    

    @IBAction func back(_ sender: AnyObject) {
        
   
        coposeType.setContentOffset(CGPoint(x:0,y:0), animated: true)
        backcons.constant = 0
        closeCons.constant = 0
        self.backButn.alpha = 1
        UIView.animate(withDuration: 0.25, animations: {
            
            self.layoutIfNeeded()
            }) { (_) in
                self.backButn.alpha = 0
                self.backButn.isHidden = true
        }
        
    }
    //关闭页面
    @IBAction func close(_ sender: AnyObject) {
        //关闭动画
        hidneButn()
        //removeFromSuperview()
    }
}

private extension LGCoompostType{
    
    //关闭动画
    func hidneButn(){
        let page = Int(coposeType.contentOffset.x/coposeType.bounds.width)
        let v = coposeType.subviews[page]
        //遍历出按钮
        for (i,btn) in v.subviews.enumerated().reversed() {
            
            //进行弹性动画
            let animati:POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            animati.fromValue = btn.center.y
            animati.toValue = btn.center.y + 350
            
            animati.beginTime = CACurrentMediaTime() + CFTimeInterval(v.subviews.count - i) * 0.025
            
            btn.pop_add(animati, forKey: nil)
            //监听最后一个按钮
            if i == 0 {
                animati.completionBlock = { _,_ in
                    //
                   self.alphView()
                }
            }
            
            
        }
        
        
    }
    
    
    //最后一个按钮动画文采隐藏视图
    func alphView(){
        let anima:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        anima.fromValue = 1
        anima.toValue = 0
        anima.duration = 0.25
        pop_add(anima, forKey: nil)
        anima.completionBlock = {_ ,_ in
            self.removeFromSuperview()
            
        }
        
        
    }
    
    

    
    
    //显示动画
    func animati(){
        // 1> 创建动画
        let anim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
    
        
        anim.fromValue = 0
        anim.toValue = 1
        anim.duration = 0.5
        
        // 2> 添加到视图
        pop_add(anim, forKey: nil)
        buttonAnimati()
        
    }
    
    //按钮弹跳动画
    func buttonAnimati(){
        
        let v = coposeType.subviews[0]
        //遍历出按钮
        for (i,butn) in v.subviews.enumerated(){
            let animati:POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            animati.fromValue = butn.center.y + 350
            animati.toValue = butn.center.y
                        animati.springBounciness = 12
            animati.springSpeed = 8
            butn.pop_add(animati, forKey: nil)
            animati.beginTime = CACurrentMediaTime() + CFTimeInterval(i) * 0.025
            
            
            
            
        }
    
    
    
    
    }
    
    
    
    
    
    
}

