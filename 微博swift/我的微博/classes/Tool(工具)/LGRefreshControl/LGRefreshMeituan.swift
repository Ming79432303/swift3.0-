//
//  LGRefreshMeituan.swift
//  下拉刷新
//
//  Created by ming on 16/10/18.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

class LGRefreshMeituan: LGRefresView {

    @IBOutlet weak var earthIcon: UIImageView!
    @IBOutlet weak var kangrooIcon: UIImageView!
    @IBOutlet weak var buildingIcon: UIImageView!
    
  override  var parentViewHeight:CGFloat{
        didSet{
            let refvalue:CGFloat = 120.0
            if parentViewHeight < 30 {
                return
            }
            
        var scale = parentViewHeight/refvalue
        
            if parentViewHeight > refvalue {
                scale = 1
            }
            
            kangrooIcon.transform = CGAffineTransform(scaleX: scale, y: scale)
            
        }
        
    }
    
    override func awakeFromNib() {
        
        let image1 = UIImage(named: "icon_building_loading_1")
        let image2 = UIImage(named: "icon_building_loading_2")
        buildingIcon.image = UIImage.animatedImage(with: [image1!,image2!], duration: 0.5)
        let animati = CABasicAnimation(keyPath: "transform.rotation")
        animati.toValue = -2 * M_PI
        animati.repeatCount = MAXFLOAT
        animati.isRemovedOnCompletion = false
        animati.duration = 5
        earthIcon.layer.add(animati, forKey: nil)
        kangrooIcon.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        let kangarooY = self.frame.height - 24
        
        let kimage1 = UIImage(named: "icon_small_kangaroo_loading_1")
        let kimage2 = UIImage(named: "icon_small_kangaroo_loading_2")
        kangrooIcon.image = UIImage.animatedImage(with: [kimage1!,kimage2!], duration: 0.5)

        
        kangrooIcon.center = CGPoint(x: self.frame.width / 2, y: kangarooY)
        kangrooIcon.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        
     
    }
    

}
