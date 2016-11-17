//
//  LGWelcom.swift
//  我的微博
//
//  Created by ming on 16/10/9.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit
import SDWebImage
class LGWelcom: UIView {
    @IBOutlet weak var bottomContraints: NSLayoutConstraint!
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    class func welcomView() ->LGWelcom{
    let welView = UINib(nibName: "LGWelcom", bundle: Bundle.main)
     
      let v = welView.instantiate(withOwner: nil, options: [:])[0]
        
        
        return v as! LGWelcom
        
        
    }
    
   required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
        
        icon.layer.cornerRadius = 85
        icon.layer.masksToBounds = true
        name.text = LGNetWorkingManager.shared.userAccess.name ?? "欢迎回来"
        
        let avatar =  LGNetWorkingManager.shared.userAccess.avatar_large
         icon.lg_setImage(urlSting: avatar, placeholderImage: UIImage(named: "visitordiscover_image_profile"))
      
    
        
    }
    /// 视图被添加到 window 上，表示视图已经显示
    override func didMoveToWindow() {
    
            super.didMoveToWindow()
   

            //先固定主原来的约束，不然下面直接做动画时约束还没添加完成，就会造成所有的约束都做动画
             self.layoutIfNeeded()
            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
                self.bottomContraints.constant = self.bounds.height - 200
                self.layoutIfNeeded()
                
                }, completion: { (_) in
                   
                   UIView.animate(withDuration: 1.0, animations: {
                    self.name.alpha = 1
                    }, completion: { (_) in
                        self.removeFromSuperview()
                   })
            })
        
            
        }


    
}
