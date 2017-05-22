//
//  ViewController.swift
//  FYPDBManager_swfit
//
//  Created by 凤云鹏 on 2017/5/18.
//  Copyright © 2017年 FYP. All rights reserved.
//

import UIKit


class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    
    var userList = NSMutableArray()
    var userTable: UITableView = UITableView()
    static let USERCell = "USERCell"
    var editState = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.setUI()
        
//        FYPDBManager.shareInstance.openDB("fypdb.sqlite")
        let user1 = ["UserID":"20170101","LoginID":"20170101","LoginPassword":"fyp111","UserName":"凤云鹏","Age":Int(19),"Title":"插入一条数据"] as [String : Any]
        let user = User.init(dict: user1 as [String : Any])
        FYPDBManager.shareInstance.insertUser(user: user)
        userList = FYPDBManager.shareInstance.getAllUser()
        userTable.reloadData()

    }
    
    func setUI() {
        //实例化导航条
        let navigationBar = UINavigationBar(frame:CGRect(x:0,y:20,width:self.view.frame.size.width,height:44))
        let navigationItem = UINavigationItem()
        //创建右边按钮
        let rightBtn = UIBarButtonItem(title: "+", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ViewController.clickRightButton))

        //设置导航栏标题
        navigationItem.title = "数据库增删"
        //设置导航项右边的按钮
        navigationItem.setRightBarButton(rightBtn, animated: true)
        navigationBar.pushItem(navigationItem, animated: true)
        self.view.addSubview(navigationBar)
        
        userTable = UITableView(frame: CGRect(x:0,y:64,width:self.view.frame.size.width,height:self.view.frame.size.height-64), style: UITableViewStyle.plain)
        userTable.delegate = self;
        userTable.dataSource = self;
        userTable.register(UITableViewCell.self, forCellReuseIdentifier: ViewController.USERCell)
        self.view.addSubview(userTable)
    }

    func clickRightButton()  {
        print("编辑")
        editState = !editState
        self.userTable.setEditing(editState, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userList.count
    }
    
    //tableViewCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewController.USERCell)
        
        let user = self.userList[indexPath.row] as! User
        cell?.textLabel?.text = "\(user.UserName!)"
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if editState
        {
          return UITableViewCellEditingStyle.insert
        }
        return UITableViewCellEditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            let user = self.userList[indexPath.row] as! User
            //删除数据源当前的数据
            self.userList .removeObject(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            
            FYPDBManager.shareInstance.deleteUserForUserID(userID: user.UserID!)
            
        }else if editingStyle == UITableViewCellEditingStyle.insert {
            
            let user1 = ["UserID":"2017010"+String(self.userList.count),"LoginID":"20170101","LoginPassword":"fyp111","UserName":"凤云鹏"+String(self.userList.count),"Age":Int(19),"Title":"插入一条数据"] as [String : Any]
            let user = User.init(dict: user1 as [String : Any])
            self.userList.insert(user, at: indexPath.row+1)
            
            let index = IndexPath.init(row: indexPath.row+1, section: 0)
            self.userTable.insertRows(at: [index], with: UITableViewRowAnimation.fade)
            FYPDBManager.shareInstance.insertUser(user: user)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

