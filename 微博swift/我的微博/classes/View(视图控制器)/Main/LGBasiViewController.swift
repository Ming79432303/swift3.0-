//
//  LGBasiControllerViewController.swift
//  我的微博
//
//  Created by ming on 16/10/1.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

class LGBasiViewController: UIViewController {
    
    //保存访客视图数据的字典
    var visitorViewDict:[String:String]?
    
  //懒加载
    lazy var navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.cz_screenWidth(), height: 64))
    lazy var navItem = UINavigationItem()
   //添加tableview需要的时候就有不需要的时候就没有
    var tableView:UITableView?
    //下拉刷新控件
    lazy var refreshControl:LGRefreshControl = LGRefreshControl()
    // 下拉刷新状态
    var isDownFull = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
         setUI()
     ///有token就加载数据
        LGNetWorkingManager.shared.userShouldLogon ? loadData():()
        
        //接收通知
        NotificationCenter.default.addObserver(self, selector: #selector(longinNotification), name: NSNotification.Name(rawValue: userLoginNotification), object: nil)
    }
    //重写set titlr方法
    override var title: String?{
        didSet{
      navItem.title = title
            
        }
    }
    
    //加载数据方法
    func loadData(){
        //如果子类不实现任何方法，默认关闭刷新控件
        refreshControl.endRefreshing()
        
    }
    deinit {
        //移除通知
        NotificationCenter.default.removeObserver(self)
    }
  
   
}


//MARK setUI
extension LGBasiViewController{
    //登录事件
   @objc private func login(){
        
       NotificationCenter.default.post(name: NSNotification.Name(rawValue: LGwbUserShoulLoginNotification), object: self)
    
    }
    //注册事件
  @objc  private func rigiet(){
        
        print("注册")
    }
    
    //接收到通知登录成功
@objc  func longinNotification(){
   
        //view = nil//生命周期，会调用viewDidLoad（） ->setUI()//经过测试view真的会变nil
    //setUI()
    //viewDidLoad（）还会再次注册通知
    
    setUI()
    
    LGNetWorkingManager.shared.userShouldLogon ? loadData():()
     NotificationCenter.default.removeObserver(self)
    
    }
  
    
    //布局UI视图
   func setUI(){
        view.backgroundColor = UIColor.cz_random()
        //添加navBar
        setNavgaionBar()
    
      
        //取消自动的偏移位置,隐藏掉系统的tabbar会默认有20个距离
       automaticallyAdjustsScrollViewInsets = false
        //设置访客视图  //添加表格视图
        LGNetWorkingManager.shared.userShouldLogon ? setTableView():setvisitorView()
    
    

    }
    private func setvisitorView(){
        
        let visiView = LGVisitorView(frame: view.bounds)
        visiView.visitorDict = visitorViewDict
        visiView.logButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        visiView.regiButton.addTarget(self, action: #selector(rigiet), for: .touchUpInside)
       
        view.insertSubview(visiView, belowSubview: navBar)
        //设置左右注册登录按钮
        setletfRightBabarBUtton()
    }

    private func setNavgaionBar(){
        //隐藏系统导航条
        navigationController?.navigationBar.isHidden = true
        view.addSubview(navBar)
        //添加item
        navBar.items = [navItem]
        navBar.barTintColor = UIColor.cz_color(withHex: 0xF6F6F6)
        //设置标题文字的颜色
        navBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.darkGray]
        //设置按钮文字颜色
        navBar.tintColor = UIColor.orange
    }
    //设置左右按钮
    private func setletfRightBabarBUtton(){
        
        navItem.leftBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(login))
        navItem.rightBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(rigiet))
  
        
        
    }
    

    
    
    
}
//setTableView
extension LGBasiViewController:UITableViewDataSource,UITableViewDelegate{
    
    func setTableView(){
        
        tableView = UITableView(frame:view.bounds, style: .plain)
        //把tableview插入到导航条的下面
        view.insertSubview(tableView!, belowSubview: navBar)
      
        tableView?.dataSource = self
        tableView?.delegate = self
        //设置tableview的偏移位置
        tableView?.contentInset = UIEdgeInsets(top: navBar.bounds.height, left: 0, bottom: self.tabBarController?.tabBar.bounds.height ?? 0, right: 0)
        //修改tableview的指示器缩进
        tableView?.scrollIndicatorInsets = tableView!.contentInset
        //添加下拉刷新
        
        tableView?.addSubview(refreshControl)
        //添加下拉事件
        refreshControl.beginRefreshing()
        refreshControl.addTarget(self, action:#selector(loadData), for: .valueChanged)
       
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    //根据cell即将显示的时候来判断是否是最后一个cell(最后一组，最后一个),
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //拿出行数
        let row = indexPath.row
   
        //拿出组数
        let section = tableView.numberOfSections - 1
        //哪到最后组最后一行
       let lastIndex = tableView.numberOfRows(inSection: section)
       
        if row < 0 || section < 0 {
            return
        }
        //如果是最后一个并且不再刷新状态那么就刷新
        if row == (lastIndex - 1) && !isDownFull {
            //标记为正在下拉刷新状态
            isDownFull = true
            //加载数据
            loadData()
        }
        
        
    }
    
    
}
















