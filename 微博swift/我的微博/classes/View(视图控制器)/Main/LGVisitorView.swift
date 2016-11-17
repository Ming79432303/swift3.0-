//
//  VisitorView.swift
//  我的微博
//
//  Created by ming on 16/10/2.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

class LGVisitorView: UIView {
    //定义一个访客字典属性
    var visitorDict:[String:String]?{
        //执行set方法
        didSet{
            guard let imageName = visitorDict?["imageName"],
            let message = visitorDict?["message"] else {
                return
            }
            //如果是首页的话就不用再设置了
            if imageName == "" {
                //如果是首页就旋转动画
                animation()
                return
            }
            //改变访客视图的内容
            iconView.isHidden = true
            housView.image = UIImage(named: imageName)
            tipLable.text = message
            
            
            
        }
    }
    
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.cz_color(withHex: 0xEDEDED)
        setUI()
        
    }
   
  required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func animation(){
    
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * M_PI
        anim.repeatCount = MAXFLOAT
        anim.duration = 15
        //动画完成不移除
        anim.isRemovedOnCompletion = false
        
        iconView.layer.add(anim, forKey: nil)
        
    
    }
    
    
     //懒加载控件
    //背景转的图片
    lazy var  iconView =   UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
    //半透明图片
    lazy var coverView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
    
    
    //小房子图片
      lazy var  housView =   UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
    //显示的文字
    lazy var tipLable:UILabel = UILabel.cz_label(withText: "关注一些人, 看看有什么惊喜", fontSize: 14, color: UIColor.darkGray)
    
    //登录按钮
    lazy var logButton:UIButton = UIButton.cz_textButton("登录", fontSize: 12, normalColor: UIColor.orange, highlightedColor:UIColor.darkGray , backgroundImageName: "common_button_white_disable")
    lazy var regiButton:UIButton = UIButton.cz_textButton("注册", fontSize: 12, normalColor: UIColor.darkGray, highlightedColor:UIColor.darkGray , backgroundImageName: "common_button_white_disable")
    
}
extension LGVisitorView{
    
    func setUI(){
        addUI()
        setConstraint()
       tipLable.textAlignment = .center
        
    }
    private func addUI(){
        addSubview(iconView)
        addSubview(coverView)
        addSubview(housView)
        addSubview(tipLable)
        addSubview(logButton)
        addSubview(regiButton)
    }
    private func setConstraint(){
    //先取消
        for v in subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        //圆圈
        addConstraint(NSLayoutConstraint(item: iconView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: iconView, attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerY,
                                         multiplier: 1.0,
                                         constant: -60))
        
        //房子
        addConstraint(NSLayoutConstraint(item: housView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: iconView, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: housView, attribute: .centerY, relatedBy: .equal, toItem: iconView, attribute: .centerY, multiplier: 1.0, constant: 0))
        //文字
        addConstraint(NSLayoutConstraint(item: tipLable, attribute: .centerX, relatedBy: .equal, toItem: iconView, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: tipLable, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 200))
        
        
        addConstraint(NSLayoutConstraint(item: tipLable, attribute: .centerY, relatedBy: .equal, toItem: iconView, attribute: .centerY, multiplier: 1.0, constant: 100))
        
        //登录
        addConstraint(NSLayoutConstraint(item: logButton, attribute: .top, relatedBy: .equal, toItem: tipLable, attribute: .top, multiplier: 1.0, constant: 50))
        addConstraint(NSLayoutConstraint(item: logButton, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 30))
         addConstraint(NSLayoutConstraint(item: logButton, attribute: .rightMargin, relatedBy: .equal, toItem: regiButton, attribute: .left, multiplier: 1.0, constant: -30))
        
        
        
        //注册
        
        addConstraint(NSLayoutConstraint(item: regiButton, attribute: .centerY, relatedBy: .equal, toItem: logButton, attribute: .centerY, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: regiButton, attribute: .width, relatedBy: .equal, toItem: logButton, attribute: .width, multiplier: 1.0, constant: 0))
         addConstraint(NSLayoutConstraint(item: regiButton, attribute: .height, relatedBy: .equal, toItem: logButton, attribute: .height, multiplier: 1.0, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: regiButton, attribute: .leftMargin, relatedBy: .equal, toItem: logButton, attribute: .right, multiplier: 1.0, constant: 30))
        addConstraint(NSLayoutConstraint(item: regiButton, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: -30))

        //半透明图片
        //VFL可视化语言
        //水平方向
        let viewDict:[String:Any] = ["coverView":coverView,
                        "regiButton":regiButton]
        let zero = 0
        
        let metres = ["zero":zero]
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[coverView]-0-|", options: [], metrics: nil, views:viewDict ))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[coverView]-0-[regiButton]", options: [], metrics: metres, views:viewDict ))
        
    }

        
    }
    
    

