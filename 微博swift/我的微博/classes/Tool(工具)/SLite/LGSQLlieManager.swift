//
//  LGSQLlieManager.swift
//  数据库
//
//  Created by ming on 16/10/24.
//  Copyright © 2016年 ming. All rights reserved.
//

import Foundation
import FMDB

class LGSQLlieManager{
    
    //创建一个过期书剑
    let expirationDate = -5 * 24 * 60 * 60
    
    //创建一个单例
    static let shared = LGSQLlieManager()
    ///数据库队列
    let  queue:FMDatabaseQueue
    
    private init() {
        //数据库的全路径
        let dbName = "status.db"
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        path = (path as NSString).appendingPathComponent(dbName)
        
        print("数据库路径" + path)
        
        
        queue = FMDatabaseQueue(path: path)
        
       
        
        creaTable()
        //创建监听者
        NotificationCenter.default.addObserver(self, selector: #selector(cleatDb), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        
    }
    deinit {
        // 注销通知
        NotificationCenter.default.removeObserver(self)
    }

    
    /// 清理数据缓存
    /// 注意细节：
    /// - SQLite 的数据不断的增加数据，数据库文件的大小，会不断的增加
    /// - 但是：如果删除了数据，数据库的大小，不会变小！
    /// - 如果要变小
    /// 1> 将数据库文件复制一个新的副本，status.db.old
    /// 2> 新建一个空的数据库文件
    /// 3> 自己编写 SQL，从 old 中将所有的数据读出，写入新的数据库！
    @objc private func cleatDb(){
        let dateString = Date.cz_dateString(delta: TimeInterval(expirationDate))
    
        print("清理数据库")
        //准备SQL
        let sql = "DELETE FROM T_Status WHERE createTime < ?;"
        
        //执行SQL
        queue.inDatabase { (db) in
            if db?.executeUpdate(sql, withArgumentsIn: [dateString]) == true {
                 print("删除了 \(db?.changes()) 条记录")
            }
         
        }
        
        
    }
 
}

//微博数据操作

extension LGSQLlieManager{
    
    //从数据库中加载微博数据
    ///
    ///
    /// - parameter userid:   当前登录的号码，小号
    /// - parameter since_id:   带此参数会返回比当前>id早的数据
    /// - parameter max_id:     带此参数会返回比当前<=id晚的数据所以后面要-1防止出现重复的微博
    /// - parameter max_id:
    ///
    /// - returns: 加载结果返回
    func loadStatus(userid:String,since_id:Int64 = 0 ,max_id:Int64 = 0) -> [[String:AnyObject]] {
        let sinc = 102
        var sql = "SELECT statusid, userid, status FROM T_status\n"
        sql += "WHERE userid = 1\n"
        if since_id > 0 {
             sql += "AND statusid > \(sinc)\n"
        }else if max_id > 0{
             sql += "AND statusid < \(max_id)\n"
        }
        sql += "ORDER BY statusid DESC LIMIT 20;"
        //创建数据数组
        
        var dictArray = [[String:AnyObject]]()
        //查询数据
        let array = execRecordSet(sql: sql)
        
        for dict in array {
            
            //获取status数据
         guard   let data = dict["status"] as? Data ,
            //反序列化
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [String : AnyObject]else{
                
                continue
            }
            //追加数据
            dictArray.append(json)
        }
       
        
        return dictArray
    }
    
    
    
    
    //更新数据库，同名则更新，没有则添加
    func updateStatus(userid:String ,array:[[String:AnyObject]]){
    
        //准备SqL
    /// statusid 要保存的微博代号
    //userid 当前登录用户
    //status 完整微博字典 json 数组，二进制数据
    let sql = "INSERT OR REPLACE INTO T_status (statusid, userid, status) VALUES (?,?,?);"
        
        //执行SQL
        queue.inTransaction { (db, rollBack) in
            
            //遍历数据,逐条插入微博数据
            for dict in array {

          
                //从字典获取微博代号/将字典转换成二进制json数据
                guard  let statusid = dict["idstr"] as? String ,
                    //转换json数据
                    let jsonData = try? JSONSerialization.data(withJSONObject:dict, options: []) else {
                        
                        continue
                }
                //对应sqlVALUES的三个问号参数
                if db?.executeUpdate(sql, withArgumentsIn: [statusid, userid, jsonData]) == false{
                    
                    
                    //需要回滚
                    //xcode 的自动语法转换，不会处理此处
                    //swift 1.x & 2.x => rollback.memory = true
                    rollBack?.pointee = true
                    
                    
                    break
                }
        
        }
        
        
        }
        
    
    }
    
}



//创建数据库以及私有方法
extension LGSQLlieManager{
    
    
    //查询数据库
    func execRecordSet(sql:String) ->[[String:AnyObject]]{
        
        var result = [[String:AnyObject]]()
        queue.inDatabase { (db) in
            
            guard let rs = db?.executeQuery(sql, withArgumentsIn: [])else {
                
                return
            }
            //逐行遍历结果集合
            while rs.next(){
                //1>列数
                let colCount = rs.columnCount()
                //2>遍历所有列
                for col in 0..<colCount {
                    
                    //3>列名-> key
                    guard  let name = rs.columnName(for: col),
                        //4>值 -> value
                        let value = rs.object(forColumnIndex: col) else {
                            
                            continue
                    }
                    
                    result.append([name:value as AnyObject])
                    
           
                    
                }
                
                
                
            }
            
            
        }
        return result
    }
    
    
    
    
    
    //创建数据库
    func creaTable(){
        
        //1.获取SQL
        guard  let path = Bundle.main.path(forResource: "status.sql", ofType: nil),
        let sql = try? String(contentsOfFile: path)
         else {
            
            return
        }
        

        //执行SQL
        //FMDB 中是串行队列同步执行，每次访问只允许一个线程，
        //可以保证同一时间内，只允许有一个任务访问，这样就保证了数据的安全性
        queue.inDatabase { (db) in
         if  db?.executeStatements(sql) == true{
            
            print("创表成功")
         }else{
            
            print("创表失败")
            }
        }
        
        
        
        
    }
    
}


