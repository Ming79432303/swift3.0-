//
//  LGNewFeatures.swift
//  我的微博
//
//  Created by ming on 16/10/9.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

class LGNewFeatures: UIView {


    @IBOutlet weak var goWeibo: UIButton!
    @IBOutlet weak var page: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
        class func featureView() ->LGNewFeatures{
    let nib = UINib(nibName: "LGNewFeatures", bundle: Bundle.main)
           let v = nib.instantiate(withOwner: nil, options: [:])[0] as! LGNewFeatures
          v.frame = UIScreen.main.bounds
            v.backgroundColor = UIColor.clear
         return v
        }

        required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
        }

    override func awakeFromNib() {
        let count = 4
        let rect = UIScreen.main.bounds
        
        
        for i in 0..<count {
             let imageV = UIImageView(image: UIImage(named: "new_feature_\(i+1)"))
            
            imageV.frame = CGRect(x:UIScreen.main.bounds.width * CGFloat(i) , y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            scrollView.addSubview(imageV)
        }
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
         scrollView.contentSize = CGSize(width: rect.width * CGFloat(count + 1), height: 0)
        scrollView.delegate = self
    }
    @IBAction func go2(_ sender: AnyObject) {
        removeFromSuperview()
    }
   
}

//scroviewDlegate

extension LGNewFeatures:UIScrollViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
          let p = Int(scrollView.contentOffset.x/UIScreen.cz_screenWidth() + 0.5)
        if p == (scrollView.subviews.count){
            removeFromSuperview()
        }
//        goWeibo.isHidden = false
     goWeibo.isHidden  = (p != scrollView.subviews.count - 1)
//        goWeibo.isHidden = (p != scrollView.subviews.count - 1)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       goWeibo.isHidden = true
        let p = Int(scrollView.contentOffset.x/UIScreen.cz_screenWidth() + 0.5)
        
        page.currentPage = p
        
       
            page.isHidden = (p == scrollView.subviews.count)
        
    }
    
}






