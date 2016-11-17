//
//  LGTitleBUtton.swift
//  我的微博
//
//  Created by ming on 16/10/9.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

class LGTitleBUtton: UIButton {

    init(title:String?) {
        super.init(frame: CGRect())
              if title == nil {
            setTitle("首页", for: .normal)
        }else{
            setTitle(title, for: .normal)
            setTitleColor(UIColor.darkGray, for: .normal)
           titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
           setImage(UIImage(named:"navigationbar_arrow_down"), for: .normal)
           setImage(UIImage(named:"navigationbar_arrow_up"), for: .selected)
        }
       sizeToFit()
       
       
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let titleLabel = titleLabel,let imageView = imageView
            else {
            return
        }
        if imageView.frame.midX < titleLabel.frame.midX {
            titleLabel.frame = titleLabel.frame.offsetBy(dx: -imageView.bounds.width, dy: 0)
            imageView.frame = imageView.frame.offsetBy(dx: titleLabel.bounds.width, dy: 0)

        }
        
        
    }
    
    
    
}
