//
//  LGWeiBoStatusList.swift
//  我的微博
//
//  Created by ming on 16/10/6.
//  Copyright © 2016年 ming. All rights reserved.
//

import Foundation
import YYModel
import SDWebImage


//视图模型
class LGWeiBoStatusList{
    private let maxFulldownReload = 3
    //懒加载模型数组
    lazy var modelArray = [LGWeiBoStatus]()
      var fullDownReload = 0
    //请求网络数据
    /// 加载数据添加到模型数组
    ///
    /// - parameter isFull:     是否是下拉刷新
    /// - parameter complition: 成功回调
    func loadData(isFull:Bool, complition:@escaping (_ isSuccess:Bool ,_ shouldReload:Bool)->()) {
      
        
        //处理最大刷新数
        if isFull && fullDownReload > maxFulldownReload {
            
            complition(true, false)
            return
        }
        
        let sinceid = modelArray.first?.status.id ?? 0
        let maxid = modelArray.last?.status.id ?? 0
        //如果是下拉刷新
      let since_id  = isFull ?  0 : sinceid
        //
        let max_id = !isFull ? 0: maxid
        print("最后一条微博\(modelArray.last?.status.text)")
        
        WBStatusListDAL.statusListDAL(since_id: since_id, max_id: max_id) { (json, isSuccess) in
        
        //转换为模型数组,提出出数组里面的字典
        var array = [LGWeiBoStatus]()//临时保变量的数组
        for dict in json {
            //把字典转出成模型
            //先转换成微博模型，再转换成单条微博数据模型
            guard  let status = LGWeiboModel.yy_model(with: dict) else {
                //如果为空不能return ，往下走
                continue
            }

            //字典转模型
        array.append(LGWeiBoStatus(model: status))
        
  
        }
        
        
      print(array)
        //上下拉刷新逻辑判读
        if isFull {
            
            self.modelArray += array
        }else{
              self.modelArray = array + self.modelArray
        }
        //判断最大下拉次数
        if array.count == 0 && isFull{
            
            self.fullDownReload += 1
            complition(isSuccess, false)
        }else{
            //跟新单张图片的frame,因为智力可以取到当前所有的微博图片
            //这里吧执行刷新表格的方法传递过去等吧图片下载完成再计算好单张图片的frame之后在调用
            self.scanlePicUrl(statusArray: array, complition: complition)
        }
   
        print("刷新了\(array.count)条")
}
}
}

//下载单张图片，下载完毕之后再调用传过来的闭包，再刷新tableviewView
extension LGWeiBoStatusList{
    //闭包作为最为参数，图片下载完成才刷新表格
    func scanlePicUrl(statusArray:[LGWeiBoStatus]?,complition:@escaping (_ isSuccess:Bool ,_ shouldReload:Bool)->())->(){
        
        let group = DispatchGroup()
   
         var lengt = 0
        //遍历数组中的单挑微博模型
        for pic in statusArray ?? [] {
            
            let picUrls = pic.picUrlS
            //判断是否是一张图
            if picUrls?.count != 1 {
                continue
            }
            //如果是一张图
            guard let picurl = picUrls![0].thumbnail_pic,
                let url =  URL(string:picurl ) else {
                return
            }
            //下载图片
            //创建队列组
         //进入组
        group.enter()
            
        SDWebImageManager.shared().downloadImage(with: url, options: [], progress: nil, completed: { (image, _, _, _, _) in
            print("要下载的图片的urL:\(url)")
            //下载图片
            if let image = image, let data = UIImagePNGRepresentation(image){
                lengt += data.count
                //把下载单张图片的串过去计算出frame，更新frame
                //图片下载完毕，根据当前下载图片的frame可以计算出一张图片的frame
                //缓存完一张就更新一张
                  pic.scanPicImage(image:image)
            }
            //离开组
            group.leave()
           
        })
            
        }
       
        //所有图片下载完成
        group.notify(queue: DispatchQueue.main) { 
            print("图像下载完成大小为:\(lengt/102)k")
            //执行成功回调刷新表格
            complition(true, true)
        }
    
    }
    
    
    
}

        






