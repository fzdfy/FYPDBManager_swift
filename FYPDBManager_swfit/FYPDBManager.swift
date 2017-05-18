//
//  FYPDBManager.swift
//  FYPDBManager_swfit
//
//  Created by 凤云鹏 on 2017/5/18.
//  Copyright © 2017年 FYP. All rights reserved.
//

import UIKit

class FYPDBManager: NSObject {
    //单例
    static let shareInstance :FYPDBManager = FYPDBManager()
    ///创建一个dataBase的一个全局对象
    var db: FMDatabase?
    //数据库队列
    var dbQueue : FMDatabaseQueue?

    func openDB(_ dbName:String)
    {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        db = FMDatabase(path:"\(path)\(dbName)")
        if db!.open()
        {
            print("创建数据库成功!")
            if onCreateTable()
            {
                print("创建用户表成功!")
            }
            else
            {
                print("创建用户表失败!")
            }
            db!.close()
        }else
        {
            print("创建数据库失败!")
        }
    }
    
    /// 创建表
    ///
    /// - Returns: <#return value description#>
    func onCreateTable() -> Bool {
        ///创建表
        let sql = "CREATE TABLE IF NOT EXISTS t_Users (UserId TEXT NOT NULL, LoginId TEXT NOT NULL, loginPassword TEXT, UserName TEXT, Age INTEGER, Title TEXT, PRIMARY KEY (UserId));"
        
            return try db!.executeUpdate(sql, withArgumentsIn: [])
    }
    
    //插入列表
    func insertUser(user:NSDictionary)
    {
        if db!.open()
        {
            let sql = "INSERT INTO t_Users (UserId,LoginId,loginPassword,UserName,Age,Title) VALUES (?,?,?,?,?,?);"
            let result = db!.executeUpdate(sql, withArgumentsIn: [user["UserId"]!,user["LoginId"]!,user["loginPassword"]!,user["UserName"]!,user["Age"]!,user["Title"]!])
            if result
            {
                print("数据插入成功!")
            }
            db!.close()
        }

    }
    
    func getAllUser() -> Array<Any> {
        
        var userList = Array<Any>()
        if db!.open()
        {
            
            let sql = "select * from t_Users"
            let result = db!.executeQuery(sql, withArgumentsIn: [])
            while (result?.next())! {
                let list = ["UserId":result?.string(forColumn: "UserId"),
                "LoginId":result?.string(forColumn: "LoginId"),
                "loginPassword":result?.string(forColumn: "loginPassword"),
                "UserName":result?.string(forColumn: "UserName"),
                "Age":result?.string(forColumn: "Age"),
                "Title":result?.string(forColumn: "Title"),
                ]
                userList.append(list)
            }
        
            db!.close()

        }
        return userList
    
    }
    
}
