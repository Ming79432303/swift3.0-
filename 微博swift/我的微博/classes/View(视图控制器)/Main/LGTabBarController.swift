
//
//  LGTabBarController.swift
//  我的微博
//
//  Created by ming on 16/10/1.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

class LGTabBarController: UITabBarController {
    //懒加载
    lazy var centerButton:UIButton = UIButton.cz_imageButton("tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")
   var timer:Timer?

   override func viewDidLoad() {
        super.viewDidLoad()
        setChiledControllers()
        setButton()
     self.timerReload()
    self.delegate = self
    //通知
    notification()
    //是否进去新特性
    isVersion()
    
    }
    //设置支持方向
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        //竖直方向
        return .portrait
    }
    func composeDidClick(){
        
        //显示拽写界面
    let v = LGCoompostType.compostTypeView()
       v.show {[weak v]  (clsName) in
      
        
        guard  let clsName = clsName,
         let cls = NSClassFromString(Bundle.main.namespace + "." + clsName) as? UIViewController.Type
            else{
            v?.removeFromSuperview()
            return
        }
        
      let vc = cls.init()
        let nav = UINavigationController(rootViewController: vc)
        self.present(  nav, animated: true, completion: {
            
            v?.removeFromSuperview()
            
        })
        
        
        }
       
        
        
       
    }
    ///通知
    func notification(){
        NotificationCenter.default.addObserver(self, selector: #selector(noti), name: NSNotification.Name(rawValue: LGwbUserShoulLoginNotification), object: nil)
        
        
    }
   @objc func noti(n:Notification){
    
    
    
    print("登录\(n)")
    
    //切换到登录
    
    //如果nsobj有值那么就延迟两秒
    
        let nv = UINavigationController(rootViewController: LGAuthController())
        
       present(nv, animated: true, completion: nil)
    }
    
    deinit {
        timer?.invalidate()
        //注销通知
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension LGTabBarController:UITabBarControllerDelegate{
    //处理穿帮事件，误差点处理
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        
        let index = (tabBarController.childViewControllers as NSArray).index(of: viewController)

        //selectedIndex当前选择的索引
        if index == 0  && selectedIndex == index{
            let nav = tabBarController.viewControllers?[0] as? LGNavigationController
            let vc = nav?.childViewControllers[0] as? LGHomeViewController
            //拿到即将跳转控制器索引

            vc?.tableView?.setContentOffset(CGPoint(x: 0, y: -64), animated: true)
            //延时处理
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                LGNetWorkingManager.shared.userShouldLogon ? vc?.loadData():()

            })
            
        }
        
        
         //isMember判断是哪个类不包括子类
        return !viewController.isMember(of: UIViewController.self)
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
    }
}

//定时器
extension LGTabBarController{
    func timerReload(){
    timer  =  Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(time), userInfo: nil, repeats: true)
    
    }
    
 @objc func time(){
    
    if !LGNetWorkingManager.shared.userShouldLogon {
        return
        
    }
    LGNetWorkingManager.shared.unreadCount { (count) in
        print("未读微博数量\(count)")
        self.tabBar.items?[0].badgeValue = count > 0 ? "\(count)" : nil
        UIApplication.shared.applicationIconBadgeNumber = count
        
    }

   
    }
    
}



//分割代码
extension LGTabBarController{
    
    //设置中单+号按钮
      func setButton(){
        let butnW = tabBar.bounds.size.width/5.0
        //设置中间按钮的位置dx距离父控件最两边的水平距离，垂直上下dy: 0
        centerButton.frame = tabBar.bounds.insetBy(dx:2*butnW, dy: 0)
        
        
        tabBar.addSubview(centerButton)
        
        centerButton.addTarget(self, action:#selector(composeDidClick), for: .touchUpInside)
        
      
        
    }
    
    
    
    //设置子控制器
  func  setChiledControllers(){
    
//    //转换为NSArray
//    let dict = dictArray as NSArray
//    //数组转化成json序列化
//    let data = try? JSONSerialization.data(withJSONObject: dict, options: [.prettyPrinted]) as NSData
//    data?.write(toFile: "/Users/ming/Desktop/LGWeibo/dict.json", atomically: true)
    
    //读取json数据
    let path =  NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
    
    let pathName =  path.appendingPathComponent("json.json")
     var data = NSData(contentsOfFile: pathName)
    //判断是否从沙盒目录中去数据
    //如果眉头就用默认的
    if data == nil {
        let path = Bundle.main.path(forResource: "dict.json", ofType: nil)
        data = NSData(contentsOfFile: path!)
    }
    
    guard let dictArray = try? JSONSerialization.jsonObject(with: data as! Data, options: []) as? [[String:AnyObject]]
    else {
        
        return
    }
    
    
    
    
    //创建一个用来保存控制器的数组
    var arrayM = [UIViewController]()
    
    
    //遍历创建控制器
    for dict in dictArray! {
        
      arrayM.append(setViewcontrollers(dict: dict ))
    }
    //设置tabar控制器的主控制器
    viewControllers = arrayM
    
    
    
    
    }
    //根据传来的字典生成控制器，反射机制
    private func setViewcontrollers(dict:[String:AnyObject])->UIViewController{
        
      //swift的控制器命名，项目名称+.+类名

        //根据与info.plist获取项目名称
        let name = Bundle.main.namespace
        //拼接名称 //转换类型
       //转换为String类型
        guard  let clsName = dict["className"] as? String,
        let titl = dict["title"] as? String,
        let imageName = dict["imageName"] as? String,
         let  cls = NSClassFromString(name + "." + clsName) as? LGBasiViewController.Type
     else {
            return UIViewController()
        }
        
       
      let vc = cls.init()
        //有疑问
        let nv = LGNavigationController(rootViewController: vc)
      
        vc.title = titl
//        vc.tabBarItem.title =  titl
        vc.tabBarItem.image = UIImage(named: "tabbar_" + imageName)?.withRenderingMode(.alwaysOriginal)
        //设置访客数据
        vc.visitorViewDict = dict["visitor"] as! [String : String]?
        
        
        
        vc.tabBarItem.selectedImage = UIImage(named: "tabbar_" + imageName + "_selected")?.withRenderingMode(.alwaysOriginal)
        //设置选中背景颜色，选中的字体无法改变大小，只能设置normal状态下的字体大小
        let attr = [NSForegroundColorAttributeName:UIColor.orange]
        
        vc.tabBarItem.setTitleTextAttributes(attr, for: .selected)
        //设置正常状态按钮字体大小默认为12
        vc.tabBarItem.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 12)], for: .normal)
        
        
       return nv
    }
       
    
    
}



//进入新特性进入欢迎界面
extension LGTabBarController{
    
    func isVersion(){
     
     let v = isGoNewFeaturesView() ?  LGNewFeatures.featureView():LGWelcom.welcomView()
        v.frame = UIScreen.main.bounds
        view.addSubview(v)
    }
    
    func isGoNewFeaturesView() -> (Bool){
        
        //获取当期那版本号
        let curVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? NSString ?? ""
        
        let path:String = ("version" as NSString).cz_appendDocumentDir()
        let version = try? NSString(contentsOfFile: path, encoding:String.Encoding.utf8.rawValue)
        //判断当前是否版本号相同
        if curVersion != version {
            //保存当前版本号到手机内存中中
            _ = try? curVersion.write(toFile: path, atomically: true, encoding: String.Encoding.utf8.rawValue)
            //进入新特性
            return true
        }else{
            return false
        }
    }
    
    
}











