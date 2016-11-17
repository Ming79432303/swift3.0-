//
//  LGRefresView.swift
//  下拉刷新
//
//  Created by ming on 16/10/17.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

class LGRefresView: UIView {
    @IBOutlet weak var refImage: UIImageView?
    @IBOutlet weak var tipLable: UILabel?
  
    @IBOutlet weak var activity: UIActivityIndicatorView?
     var parentViewHeight:CGFloat = 0.0
    
    var refrState:LGrefreshState = .Normal {
        didSet{
            
            switch refrState {
                case .Normal: tipLable?.text = "请使劲拉.."
                refImage?.isHidden = false
                activity?.stopAnimating()
                UIView.animate(withDuration: 0.25, animations: {
                    
                    self.refImage?.transform = CGAffineTransform.identity
                })
                refImage?.transform.inverted()
                case .PullIng: tipLable?.text = "松开刷新.."
                UIView.animate(withDuration: 0.25, animations: { 
                    
                    self.refImage?.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI)-0.001)
                })
                case .willRefresh: tipLable?.text = "正在刷新..."
                refImage?.isHidden = true
                activity?.startAnimating()
            }
            
            
            
        }
        
    }
    
    class func refresView()->LGRefresView{
        
      let re = UINib(nibName: "Refresmeituan", bundle: nil)
        
        
     return re.instantiate(withOwner: nil, options: nil)[0] as! LGRefresView
    }
   }
