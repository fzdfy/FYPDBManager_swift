//
//  FYPDBBase.swift
//  FYPDBManager_swfit
//
//  Created by 凤云鹏 on 2017/5/18.
//  Copyright © 2017年 FYP. All rights reserved.
//

import UIKit

class FYPDBBase: NSObject {
    
    //单例
//    static let shareInstance :FYPDBBase = FYPDBBase()
    ///创建一个dataBase的一个全局对象
    public var db: FMDatabase?
    //数据库队列
    public var dbQueue : FMDatabaseQueue?
    
    func checkDatabase(databaseName:String,lastVersion:Int) -> Bool {
        if databaseName.isEmpty {
            return false
        }
        
        if lastVersion < 1 {
            return false
        }
        
        db = FMDatabase(path:"\(databaseName)")
        do {
            if try !db!.open() {
                print("db open fail \(databaseName)")
               return false
            }
            let rs = db!.executeQuery("PRAGMA user_version", withArgumentsIn: []) as FMResultSet
            var oldVersion = -1
            
            if rs.next() {
                oldVersion = Int(rs.int(forColumnIndex: 0))
            }
            rs.close()
            
            if oldVersion <= 0 {//表示第一次创建数据库
                db!.inTransaction()
                var rev = onCreate(db: db!)
                if rev {
                    rev = db!.executeUpdate("PRAGMA user_version = \(lastVersion)", withArgumentsIn: [])
                    if rev {
                        db!.commit()
                    }else{
                        print(">>> db exec fail: \(db!.lastError())")
                        db!.rollback()
                    }
                }else{
                    print(">>> db exec fail: \(db!.lastError())")
                    db!.rollback()
                }
                db!.close()
                return rev
            }else{//表示已经创建了库表，接下来走onUpgrade等，由开发者在子类中决定如何升级或降级库表结构

                if lastVersion > oldVersion {
                    db!.inTransaction()
                    var rev = onUpgrade(db: db!, oldVersion: oldVersion, lastVersion: lastVersion)
                    if rev {
                        rev = db!.executeUpdate("PRAGMA user_version = \(lastVersion)", withArgumentsIn: [])
                        if rev {
                            db!.commit()
                        }else{
                            print(">>> db exec fail: \(db!.lastError())")
                            db!.rollback()
                        }
                    }else{
                        print(">>> db exec fail: \(db!.lastError())")
                        db!.rollback()
                    }
                    db!.close()
                    return rev

                }else{
                    db!.close()
                    return true
                }
            }
            
            
        } catch  {
            
        }


    }
    
    func onCreate(db:FMDatabase) -> Bool {
        return true
    }
    
    func onUpgrade(db:FMDatabase,oldVersion:Int,lastVersion:Int) -> Bool {
        return true
    }

}
