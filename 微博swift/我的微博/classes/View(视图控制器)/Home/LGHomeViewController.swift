//
//  LGHomeViewController.swift
//  我的微博
//
//  Created by ming on 16/10/1.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit
private let normalcellId = "cellnormalcellId"
private let retweitercellId = "retweitercellId"

class LGHomeViewController: LGBasiViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 注册通知
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(browserPhoto),
            name: NSNotification.Name(rawValue: WBStatusCellBrowserPhotoNotification),
            object: nil)

    }
    deinit {
        // 注销通知
        NotificationCenter.default.removeObserver(self)
    }
    /// 浏览照片通知监听方法
    @objc private func browserPhoto(n: Notification) {
        
        // 1. 从 通知的 userInfo 提取参数
        guard let selectedIndex = n.userInfo?[WBStatusCellBrowserPhotoSelectedIndexKey] as? Int,
            let urls = n.userInfo?[WBStatusCellBrowserPhotoURLsKey] as? [String],
            let imageViewList = n.userInfo?[WBStatusCellBrowserPhotoImageViewsKey] as? [UIImageView]
            else {
                return
        }
        
        // 2. 展现照片浏览控制器
        let vc = HMPhotoBrowserController.photoBrowser(
            withSelectedIndex: selectedIndex,
            urls: urls,
            parentImageViews: imageViewList)
        
        present(vc, animated: true, completion: nil)
    }


    //创建一个数据数组
   lazy var statusList = LGWeiBoStatusList()
   
    
    
    //按钮单击
     func freiend(){
     let vc =  LGTestViewController()
    navigationController?.pushViewController(vc, animated: true)
    }
    
  
    //加载数据方法
    override func loadData() {
       
//        2.00v4ddHC9AjbvDb8f17295e65iBjoB
        
        statusList.loadData (isFull: isDownFull){(isSuccsee ,shouldReload) in
            
            if shouldReload {
                //刷新tableview
               self.tableView?.reloadData()
            }
            
           
            //结束上拉刷新
            self.refreshControl.endRefreshing()
            //数据加载完成取消标记下拉刷新状态
            self.isDownFull = false

        }
    }
    
    
   
}
//表格数据源方法
extension LGHomeViewController:statusCellDelegate{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusList.modelArray.count
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     
        return statusList.modelArray[indexPath.row].rowHeight ?? 0
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = statusList.modelArray[indexPath.row]

        let cellID = (model.status.retweeted_status != nil) ? retweitercellId : normalcellId
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? LGStatusNormalCell
        cell?.delegate = self
        
              cell?.model = model
     
       return cell!
    }
    //代理方法
    func stastusDiclicCell(statusCell: LGStatusNormalCell, urlString: String) {
       guard let url = URL(string: urlString)
         else{
            return
        }
        let request = URLRequest(url: url)
        let web = LGWebcontrollwer()
         web.webview.loadRequest(request)
      
       
        self.navigationController?.pushViewController(web, animated: true)
        
    }
}


extension LGHomeViewController{
    //从写父类setTableView方法,因为这是登录之后才要做的是，所有前面的我们都不需要处理，交给基类控制器做
    override func setTableView() {
        super.setTableView()
        setNavBarButton()
     
    }
    //显示列表
 
}


// MARK: - 添加TitleView
extension LGHomeViewController{
    func setNavBarButton(){
    
        //首页好友按钮
        navItem.leftBarButtonItem = UIBarButtonItem(title: "好友", target: self, action: #selector(freiend))
        navItem.rightBarButtonItem = nil
               //注册cell
        tableView?.register(UINib(nibName: "LGStatusNormalCell", bundle: nil),   forCellReuseIdentifier: normalcellId)
        
        tableView?.register(UINib(nibName: "LGStatusRetuenTwiterlCell", bundle: nil),forCellReuseIdentifier: retweitercellId)
        
        self.tableView?.estimatedRowHeight = 100
  
        
        tableView?.separatorStyle = .none
        
      let title = LGNetWorkingManager.shared.userAccess.name
        let titleButton = LGTitleBUtton(title: title)
        navItem.titleView = titleButton
        titleButton.addTarget(self, action: #selector(showList), for: .touchUpInside)
        //自定义button
    }
    @objc private func showList(titleBtn:UIButton){
        titleBtn.isSelected = !titleBtn.isSelected
       
    }

}


