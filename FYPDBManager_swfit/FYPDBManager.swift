//
//  FYPDBManager.swift
//  FYPDBManager_swfit
//
//  Created by 凤云鹏 on 2017/5/18.
//  Copyright © 2017年 FYP. All rights reserved.
//

import UIKit

class FYPDBManager: FYPDBBase {
    //单例
    static let shareInstance :FYPDBManager = FYPDBManager()
    
    public let dbVersion:Int = 1
    
    /// 创建表

    override func onCreate(db: FMDatabase) -> Bool {
        print(">>> onCreate")
//        if db {
//            return false
//        }
        
        do {
            var result:Bool = false
            let sql = "CREATE TABLE IF NOT EXISTS t_Users (UserID TEXT NOT NULL, LoginID TEXT NOT NULL, LoginPassword TEXT, UserName TEXT, Age INTEGER, Title TEXT, PRIMARY KEY (UserID));"
            
            result = db.executeUpdate(sql, withArgumentsIn: [])
            if !result {
                print("create table Users Failed")
                return false;
            }
            
            return onUpgrade(db: db, oldVersion: 1, lastVersion: self.dbVersion)
            
        } catch  {
            return false;
        }
    }
    
/// >>> 业务逻辑
    //插入列表
    func insertUser(user:User)
    {
        if db!.open()
        {
            let sql = "INSERT INTO t_Users (UserID,LoginID,LoginPassword,UserName,Age,Title) VALUES (?,?,?,?,?,?);"
            let result = db!.executeUpdate(sql, withArgumentsIn: [user.UserID!,user.LoginID!,user.LoginPassword!,user.UserName!,user.Age as Any,user.Title!])
            if result
            {
                print("数据插入成功!")
            }
            db!.close()
        }

    }
    
    func getAllUser() -> NSMutableArray {
        
        let userList:NSMutableArray = []
        if db!.open()
        {
            let sql = "select * from t_Users"
            let result = db!.executeQuery(sql, withArgumentsIn: [])

            while (result?.next())! {
                let list:[String : AnyObject] = ["UserID":result?.string(forColumn: "UserID") as AnyObject ,
                "LoginID":result?.string(forColumn: "LoginID") as AnyObject ,
                "LoginPassword":result?.string(forColumn: "LoginPassword") as Any as AnyObject,
                "UserName":result?.string(forColumn: "UserName") as AnyObject ,
                "Age": result?.int(forColumn: "Age")as AnyObject ,
                "Title":result?.string(forColumn: "Title") as AnyObject ,
                ]
                let user = User.init(dict: list as [String : AnyObject]);
                userList.add(user)
            }
            db!.close()
        }
        return userList
    }
    
    func deleteUserForUserID(userID:String) {
        if db!.open() {
            let sql = "delete from t_Users where userID = ?"
            let result = db!.executeUpdate(sql, withArgumentsIn: [userID])
            if result {
                print("删除成功!")
            }
            db!.close()
        }
    }
    
    
    override func onUpgrade(db:FMDatabase,oldVersion:Int,lastVersion:Int) -> Bool {
        return true
    }
    
}
