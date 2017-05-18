//
//  ViewController.swift
//  FYPDBManager_swfit
//
//  Created by 凤云鹏 on 2017/5/18.
//  Copyright © 2017年 FYP. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        FYPDBManager.shareInstance.openDB("fypdb.sqlite")
        let user = ["UserId":"20170101","LoginId":"20170101","loginPassword":"fyp111","UserName":"凤云鹏","Age":"19","Title":"插入一条数据"]
        FYPDBManager.shareInstance.insertUser(user: user as NSDictionary)
        let userLiet = FYPDBManager.shareInstance.getAllUser()
        print(userLiet)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

