//
//  User.swift
//  FYPDBManager_swfit
//
//  Created by 凤云鹏 on 2017/5/19.
//  Copyright © 2017年 FYP. All rights reserved.
//

import UIKit

class User: NSObject {

    //用户ID
    var UserID: String?
    //登陆ID
    var LoginID: String?
    //登录密码
    var LoginPassword: String?
    //用户名
    var UserName: String?
    //年龄
    var Age: Int? = 19
    //新价格
    var Title: String?
    
    //地点转模型
    init(dict: [String : Any]) {
        super.init()
        //使用kvo 为当前对象的属性
        setValuesForKeys(dict)
    }
        //防止对象属性和kvo时的dict的key 不匹配而崩溃
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    


    
}
