//
//  LGRefreshControl.swift
//  我的微博
//
//  Created by ming on 16/10/17.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

enum LGrefreshState {
    ///正常状态
    case Normal
    ///即将刷新状态
    case PullIng
    ///刷新状态
    case willRefresh
}


class LGRefreshControl: UIControl {
    
    //开始刷新事件
    func beginRefreshing(){
        guard let sv = scroview else {
            return
        }
        if refreshView.refrState == .willRefresh{
            return
        }
        refreshView.refrState = .willRefresh
   
        var coten = sv.contentInset
        coten.top += Refresh
        sv.contentInset = coten
        refreshView.parentViewHeight = sv.contentInset.top
          
    }
    //结束刷新时间
    func endRefreshing(){
        
    
        guard let sv = scroview else {
            return
        }
        if refreshView.refrState != .willRefresh {
            return
        }
        var coten = sv.contentInset
        coten.top -= Refresh
        sv.contentInset = coten
        refreshView.refrState = .Normal
        
        
    }

    
    
    lazy var refreshView = LGRefresView.refresView()
    var Refresh:CGFloat = 120
    
    private weak var scroview:UIScrollView?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    /// willMove addSubview 方法调用
    ///单添加在父控件视图的时候，newSuperView是父视图
    //当俯视图被移除 newSuperView 是nil
    ///
    override func willMove(toSuperview newSuperview: UIView?)
    {
        
        guard let sv = newSuperview as? UIScrollView else {
            return
        }
        scroview = sv
     
        scroview?.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
       

    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        
     
        guard let sv = scroview else {
            return
        }
        let height = -(sv.contentInset.top + sv.contentOffset.y)

        if height < 0 {
            return
        }
        if refreshView.refrState != .willRefresh{
            
            self.refreshView.parentViewHeight = height
        }
        self.frame = CGRect(x: 0, y: -height, width: UIScreen.main.bounds.width, height: height)
        
        if sv.isDragging{
            if height < Refresh && refreshView.refrState == .PullIng{
                print("再使劲")
                refreshView.refrState = .Normal
                
            }else if height > Refresh && refreshView.refrState == .Normal{
                
                print("松开刷新")
                refreshView.refrState = .PullIng
                
            }
            
        }else{
            //判断是否已经过了临界点
            if refreshView.refrState == .PullIng {
                print("正在刷新")
                //发送事件,加载数据
              
                
                //执行刷新控件
               beginRefreshing()
                sendActions(for: .valueChanged) 
            
            }
        }
        
    }
    
    override func removeFromSuperview() {
        superview?.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    
    func setUI(){
        
        backgroundColor = superview?.backgroundColor
        
        addSubview(refreshView)
       // clipsToBounds = true
       //设置自动布局
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: refreshView.bounds.width))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .height,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: refreshView.bounds.height))  
    }
}
