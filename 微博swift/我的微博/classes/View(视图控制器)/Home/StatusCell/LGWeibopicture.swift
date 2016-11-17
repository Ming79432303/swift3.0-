//
//  LGWeibopicture.swift
//  我的微博
//
//  Created by ming on 16/10/15.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit


//微博配图xib
class LGWeibopicture: UIView {
    //计算单张图的size
    var status:LGWeiBoStatus?{
        didSet{
           
           scanleSize()
            // 设置 urls
            urls = status?.picUrlS
        }
        
    }
    
    /// 配图视图的数组
    private var urls: [LGWeiBoPicModel]? {
        didSet {
            
            // 1. 隐藏所有的 imageView
            for v in subviews {
                v.isHidden = true
            }
            
            // 2. 遍历 urls 数组，顺序设置图像
            var index = 0
            for url in urls ?? [] {
                
                // 获得对应索引的 imageView
                let iv = subviews[index] as! UIImageView
                
                // 4 张图像处理
                if index == 1 && urls?.count == 4 {
                    index += 1
                }
                
                // 设置图像
                iv.lg_setImage(urlSting: url.thumbnail_pic, placeholderImage: nil)
                
                // 判断是否是 gif，根据扩展名
                iv.subviews[0].isHidden = (((url.thumbnail_pic ?? "") as NSString).pathExtension.lowercased() != "gif")
                
                // 显示图像
                iv.isHidden = false
                
                index += 1
            }
        }
    }

    
    
    //计算单张微博图片的大小
    private func scanleSize(){
        
        //更改第0张图片的size
        let viewSize = status?.pictureSize ?? CGSize()
        if status?.picUrlS?.count == 1 {
              let imageV = subviews[0]
            let rect = CGRect(x: 0, y: WeiBoStatusPicOuterMargin, width: viewSize.width, height: viewSize.height - WeiBoStatusPicOuterMargin)
            imageV.frame = rect
            
        }else{
            //当不是大于一张图片的时候，就改回原来的
            let imageV = subviews[0]
            let rect = CGRect(x: 0, y: WeiBoStatusPicOuterMargin, width: WeiBoPicItemWidth, height:WeiBoPicItemWidth)
            imageV.frame = rect
            
        }
      
        
        
         picturBottom.constant = status?.pictureSize.height ?? 0
    }
    
    //没用
    var model:[LGWeiBoPicModel]?{
        
        didSet{
            
            for v in subviews{
                v.isHidden = true
                
            }
            var index = 0;
            for url in model ?? [] {
                
            let v = subviews[index] as! UIImageView
           
                if model?.count == 4 && index == 1 {
                    index += 1
                }
            
 
            v.lg_setImage(urlSting: url.thumbnail_pic, placeholderImage: nil)

                 v.isHidden = false
                index += 1
                
            }
         
    
        }
    
        
    }
    
    
     @IBOutlet weak var picturBottom: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
         backgroundColor = superview?.backgroundColor
      
        setUI()
    }
    // MARK: - 监听方法
    /// @param selectedIndex    选中照片索引
    /// @param urls             浏览照片 URL 字符串数组
    /// @param parentImageViews 父视图的图像视图数组，用户展现和解除转场动画参照
     func tapImageView(tap: UITapGestureRecognizer) {
        //获取点击手势的view
        guard let iv = tap.view,
            //获取微博返回的图片数组
            let picURLs = status?.picUrlS
            else {
                return
        }
        //选中的图片的index
        var selectedIndex = iv.tag
        
        // 针对四张图处理
        if picURLs.count == 4 && selectedIndex > 1 {
            selectedIndex -= 1
        }
        //拿到模型数组键值为largePic的所有字符串，并转为字符串数组
        let urls = (picURLs as NSArray).value(forKey: "largePic") as! [String]
        
        // 处理可见的图像视图数组
        //获取当前非隐藏的图像视图
        var imageViewList = [UIImageView]()
        
        for iv in subviews as! [UIImageView] {
            
            if !iv.isHidden {
                //添加到视图数组
                imageViewList.append(iv)
            }
        }
        
        // 发送通知
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: WBStatusCellBrowserPhotoNotification),
            object: self,
// MARK: - WBStatusCellBrowserPhotoURLsKey:单条图片链接的数据
            
// MARK: - WBStatusCellBrowserPhotoSelectedIndexKey 当前选中的索引
            
            
// MARK: - WBStatusCellBrowserPhotoImageViewsKey 当前显示图片的imageView视图
            userInfo: [WBStatusCellBrowserPhotoURLsKey: urls,
                       WBStatusCellBrowserPhotoSelectedIndexKey: selectedIndex,
                       WBStatusCellBrowserPhotoImageViewsKey: imageViewList])
    }
}


   
    

extension LGWeibopicture{
    
    
    //循环添加imageView
   func setUI(){
   
    
    let count = 3
  
    let rect = CGRect(x: 0, y: WeiBoStatusPicOuterMargin, width: WeiBoPicItemWidth, height: WeiBoPicItemWidth)
    
    
    for i in 0..<count * count {
        clipsToBounds = true
        
        let imageV = UIImageView()
         imageV.contentMode = .scaleAspectFill
        imageV.clipsToBounds = true
        imageV.backgroundColor = UIColor.red
        //计算frame
        let row = CGFloat(i / count)
        let lin = CGFloat(i % count)
        let xoffset = lin * (WeiBoPicItemWidth + WeiBoinnerMargin)
        let yoffset = row * (WeiBoPicItemWidth + WeiBoinnerMargin)
        
        imageV.frame = rect.offsetBy(dx: xoffset , dy: yoffset)

        addSubview(imageV)
        
        // 让 imageView 能够接收用户交互
        imageV.isUserInteractionEnabled = true
        // 添加手势识别
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapImageView))
        
        imageV.addGestureRecognizer(tap)
        
        // 设置 imageView 的 tag
        imageV.tag = i
        
        addGifView(iv: imageV)

        
        
    }
    
    }
    /// 向图像视图添加 gif 提示图像
    private func addGifView(iv: UIImageView) {
        
        let gifImageView = UIImageView(image: UIImage(named: "timeline_image_gif"))
        
        iv.addSubview(gifImageView)
        
        // 自动布局
        gifImageView.translatesAutoresizingMaskIntoConstraints = false
        
        iv.addConstraint(NSLayoutConstraint(
            item: gifImageView,
            attribute: .right,
            relatedBy: .equal,
            toItem: iv,
            attribute: .right,
            multiplier: 1.0,
            constant: 0))
        iv.addConstraint(NSLayoutConstraint(
            item: gifImageView,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: iv,
            attribute: .bottom,
            multiplier: 1.0,
            constant: 0))
    }

    
    
    
}
