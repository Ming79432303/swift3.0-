//
//  LGStatusNormalCell.swift
//  我的微博
//
//  Created by ming on 16/10/12.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

protocol statusCellDelegate:NSObjectProtocol{
    
    func stastusDiclicCell(statusCell: LGStatusNormalCell,urlString:String)
}

class LGStatusNormalCell: UITableViewCell {
    
  weak var delegate:statusCellDelegate?
    
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var tooView: LGWeiboTool!
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var frome: UILabel!
    @IBOutlet weak var vip: UIImageView!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var content: FFLabel!
    
    @IBOutlet weak var daren: UIImageView!
    //配图
    @IBOutlet weak var picture: LGWeibopicture!
    @IBOutlet weak var reText: FFLabel?
   
    var  model:LGWeiBoStatus?{
        //给cell设置数据
       
        didSet{
            content.attributedText = model?.textAttr
            name.text = model?.status.user?.screen_name
             let urlString = model?.status.user?.profile_image_url
            reText?.attributedText = model?.reTextAttr
            icon.lg_setImage(urlSting: urlString, placeholderImage: UIImage(named:"avatar_default_big"), isAvatar: true)
                vip.image = model?.vipIcon
                daren.image = model?.daren
            tooView.model = model
            //配图
            picture.model = model?.picUrlS
        //获取图片的尺寸
            picture.status = model
            
           reText?.delegate = self
            content.delegate = self
            frome.text = model?.status.source
            time.text = model?.status.createdDate?.cz_dateDescription
            
          //测试4张图的显示
//            if (model?.status.pic_urls?.count)! > 4 {
//                var pics = model?.status.pic_urls
//                pics!.removeSubrange((pics?.startIndex)! + 4..<(pics?.endIndex)!)
//                picture.model = pics
//                
//            }else{
//                
            
          
                
//            }
            
            
            
            
            
        }
        
        
    }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.white
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension LGStatusNormalCell:FFLabelDelegate {
    func labelDidSelectedLinkText(label: FFLabel, text: String) {
        if text.hasPrefix("http://"){
            delegate?.stastusDiclicCell(statusCell: self, urlString: text)
        }
    }
}



