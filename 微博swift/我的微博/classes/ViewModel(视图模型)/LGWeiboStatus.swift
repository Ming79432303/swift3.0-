//
//  LGWeiboStatus.swift
//  我的微博
//
//  Created by ming on 16/10/13.
//  Copyright © 2016年 ming. All rights reserved.
//

import Foundation

   //单条微博模型。处理业务逻辑
class LGWeiBoStatus:CustomStringConvertible{
    //vip图片
    var vipIcon:UIImage?
    //微博数据模型
    var status:LGWeiboModel
    //达人图标
    var daren:UIImage?
    //评论数
    var comments:String?
    //分享数
    var reposts: String?
    //点赞数
    var attitudes: String?
    //所有图片占用的frame
    var pictureSize = CGSize()
    //当前cell的行高
    var rowHeight:CGFloat?
    
    
    
    //更新单张图片的frame,因为确定只有一张图片
    func scanPicImage(image:UIImage){
        
        /// 使用单个图像，更新配图视图的大小
        ///
        /// 新浪针对单张图片，都是缩略图，但是偶尔会有一张特别大的图 7000 * 9000 多
        /// 新浪微博，为了鼓励原创，支持`长微博`，但是有的时候，有特别长的微博，长到宽度只有1个点
        ///
        /// - parameter image: 网路缓存的单张图像
        //图片过宽过高处理
        let maxWidth: CGFloat = 200
        let minWidth: CGFloat = 40

         var size = image.size
        //图片过窄处理
        if size.width < minWidth {
            
            // 设置最大宽度
          size.width = minWidth

            // 等比例调整高度
            size.height = size.width * image.size.height / image.size.width / 4
         
        }
        //图片过宽 处理
        if size.width > maxWidth {
            
            size.width = maxWidth
            size.height = size.width * image.size.height / image.size.width
            
        }
        //图片过高处理
        // 过高图片处理，图片填充模式就是 scaleToFill，高度减小，会自动裁切
        if size.height > 200 {
            size.height = 200
        }
        
        
        
    size.height += WeiBoStatusPicOuterMargin
    pictureSize = size
        calculateRowHeight()
        
    }
    
    
    //计算型属性
    //转发原创微博一定没有配图，如果转发没有配图那么就返回原创微博的配图
    var picUrlS:[LGWeiBoPicModel]?{

        

        return status.retweeted_status?.pic_urls ?? status.pic_urls
        
        
    }
    //转换图文混排转发内容
    var textAttr:NSAttributedString?
    //转换图文混排转发内容
    var reTextAttr:NSAttributedString?
    
    //计算型属性，转发的文本内容2
    var reText:String?{
        
        let str = "@"
            + (status.retweeted_status?.user?.screen_name ?? "")
            + "\n·"
            + (status.retweeted_status?.text ?? "")
       return str
    }
    //计算粗行高
    
    func calculateRowHeight(){
      

        
        // 原创微博：顶部分隔视图(12) + 间距(12) + 图像的高度(34) + 间距(12) + 正文高度(需要计算) + 配图视图高度(计算) + 间距(12) ＋ 底部视图高度(35)
        // 被转发微博：顶部分隔视图(12) + 间距(12) + 图像的高度(34) + 间距(12) + 正文高度(需要计算) + 间距(12)+间距(12)+转发文本高度(需要计算) + 配图视图高度(计算) + 间距(12) ＋ 底部视图高度(35)
        let margin: CGFloat = 12
        let iconHeight: CGFloat = 35
        let toolbarHeight: CGFloat = 35
        
        var height: CGFloat = 0
        
        let viewSize = CGSize(width: UIScreen.cz_screenWidth() - 2 * margin, height: CGFloat(MAXFLOAT))
        
        // 1. 计算顶部位置
        height = 2 * margin + iconHeight + margin
        
        // 2. 正文属性文本的高度
        if let text = textAttr {
           

            height += text.boundingRect(with: viewSize, options: [.usesLineFragmentOrigin], context: nil).height
        }
        
        // 3. 判断是否转发微博
        if status.retweeted_status != nil {
            
            height += 2 * margin
            
            // 转发文本的高度 - 一定用 retweetedText，拼接了 @用户名:微博文字
            if let text = reTextAttr {
                
                height += text.boundingRect(with: viewSize, options: [.usesLineFragmentOrigin], context: nil).height
            }
        }
        
        // 4. 配图视图
        height += pictureSize.height
        
        height += margin
        
        // 5. 底部工具栏
        height += toolbarHeight
        
        // 6. 使用属性记录
        rowHeight = height
        print(rowHeight)

    }
   
    
    
    init(model:LGWeiboModel) {
      
        self.status = model
        
        
        //给用户vip等级
        if (model.user?.mbrank)! > 0 && (model.user?.mbrank)! < 7 {
       let imageName = "common_icon_membership_level" + "\(model.user?.mbrank ?? 1)"
           vipIcon = UIImage(named: imageName)
           
        }
         ///认证类型,-1:没有认证，0，认证用户，2，3，4，5：企业认证，220达人
        switch model.user?.verified_type ?? -1{
        case 0 : daren = UIImage(named: "avatar_vip")
        case 2,3,4,5 : daren = UIImage(named: "avatar_enterprise_vip")
        case 220 : daren = UIImage(named: "avatar_grassroot")
        default:
            break
        }
        
        comments = setToolString(count: model.comments_count, defaultString: "评论")
        reposts = setToolString(count: model.reposts_count, defaultString: "转发")
        attitudes = setToolString(count: model.attitudes_count, defaultString: "点赞")
        
        //根据配图的数量计算出配图的size
      pictureSize = calePictureViewSize(count: picUrlS?.count)
              // --- 设置微博文本 ---
        let originalFont = UIFont.systemFont(ofSize: 15)
        let retweetedFont = UIFont.systemFont(ofSize: 14)

        
        //图文混排转换
        textAttr = CZEmoticonManager.shared.emoticonString(string: model.text ?? "", font: originalFont)
        reTextAttr = CZEmoticonManager.shared.emoticonString(string: reText ?? "", font: retweetedFont)
        
        //等图片size计算好之后在计算行高
      calculateRowHeight()

    }
    
    //计算工具栏显示逻辑
    func setToolString(count:Int ,defaultString:String) -> String {
        
        if count == 0{
            return defaultString
        }
        if count > 10000 {
            
            let str = String(format: "%.2d", Double(count/1000))
            return str
        }
        
        return count.description
    }
    
    //根据所有图片的数量来确定配图View的frame
    func calePictureViewSize(count:Int?)-> CGSize{
        
        if count == 0 || count == nil {
           return CGSize()
        }
        let WeiBoStatusPicOuterMargin = CGFloat(12)
        let WeiBoinnerMargin = CGFloat(3)
        //视图的宽度
        let WeiBoPicWidth = UIScreen.cz_screenWidth() - 2 * WeiBoStatusPicOuterMargin
        //计算出每个图片的宽度
        let WeiBoPicItemWidth = (WeiBoPicWidth - WeiBoinnerMargin * 2) / 3
        //计算出出尺寸
        //根据行数计算高度
        let row = (count! - 1) / 3 + 1
        //总的高度
        let WeiboPicheight = WeiBoStatusPicOuterMargin + WeiBoPicItemWidth * CGFloat(row) + CGFloat(row - 1) * WeiBoinnerMargin

        return CGSize(width: WeiBoPicWidth, height: WeiboPicheight)
    }
    
    
    
    var description: String{
        
        
          return status.description
    }
    
}
