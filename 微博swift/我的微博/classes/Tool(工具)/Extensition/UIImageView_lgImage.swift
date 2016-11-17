//
//  UIImageView_lgImage.swift
//  我的微博
//
//  Created by ming on 16/10/13.
//  Copyright © 2016年 ming. All rights reserved.
//

//隔离SDWebImage

import Foundation
import SDWebImage

extension UIImageView{
    
    func lg_setImage(urlSting:String?, placeholderImage:UIImage?, isAvatar:Bool = false ){
        
        
        guard let urlSting = urlSting, let url = URL(string: urlSting) else {
            
            image = placeholderImage
            return
        }
        
        sd_setImage(with: url, placeholderImage: placeholderImage, options: [], progress: nil) {[weak self] (image, _, _, _) in
            if isAvatar {
                
                
                self?.image = image?.lg_avatarImage(size: self?.bounds.size)
                
            }
        
            
        }
        
    }
    
    
    
    
}
