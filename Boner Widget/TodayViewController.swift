//
//  TodayViewController.swift
//  Boner Widget
//
//  Created by Chris on 2017/4/3.
//  Copyright © 2017年 Chris. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var loginSwitch: UISwitch!
    
    var status: String = "" {
        didSet {
            statusLabel.text = status
        }
    }
    var username: String = "" {
        didSet {
            usernameLabel.text = username
        }
    }
    var password: String = ""
    var data: String = "" {
        didSet {
            dataLabel.text = data
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        updateOfflineStatus(prompt: "OFFLINE")
        username = BonerUserDefaults.username
        if username == "" {
            username = "--"
        }
        password = BonerUserDefaults.password
        getOnlineInfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @IBAction func onLoginSwitch(_ sender: Any) {
        if loginSwitch.isOn {
            login()
        } else {
            logout()
        }
    }
    
    // MARK : - login
    
    func login() {
        
        let parameters = [
            "action": "login",
            "username": username,
            "password": password,
            "ac_id": "1",
            "user_ip": "",
            "nas_ip": "",
            "user_mac": "",
            "save_me": "1",
            "ajax": "1"
        ]
        
        BonNetwork.post(parameters, success: { (value) in
            print(value)
            if value.contains("login_ok,") || value.contains("You are already online.") || value.contains("IP has been online, please logout."){
                self.getOnlineInfo()
            } else if value.contains("Password is error.") {
                self.updateOfflineStatus(prompt: "PASSWORD ERROR")
            } else if value.contains("User not found.") {
                self.updateOfflineStatus(prompt: "USER NOT FOUND")
            } else if value.contains("Arrearage users.") {
                self.updateOfflineStatus(prompt: "ARREARAGE")
            }
            else {
                self.updateOfflineStatus(prompt: "FAIL")
            }
        }) { (error) in
            self.updateOfflineStatus(prompt: "TIMEOUT")
        }
        
    }
    
    // MARK : - logout
    
    func logout() {
        
        let parameters = [
            "action": "logout",
            "username": username,
            "password": password,
            "ajax": "1"
        ]
        
        BonNetwork.post(parameters) { (value) in
            print(value)
            self.updateOfflineStatus(prompt: "OFFLINE")
        }
    }
    
    // MARK : - get online info
    
    func getOnlineInfo() {
        
        let parameters = [
            "action": "get_online_info"
        ]
        
        BonNetwork.post(parameters, success: { (value) in
            
            NSLog(value)
            if(value == "not_online") {
                self.updateOfflineStatus(prompt: "OFFLINE")
            } else {
                self.updateOnlineStatus(value: value)
            }
            
        }) { (error) in
            self.updateOfflineStatus(prompt: "OFFLINE")
        }
    }
    
    func updateOnlineStatus(value: String) {
        status = "ONLINE"
        let info = value.components(separatedBy: ",")
        username = info[4]
        data = BonerFormat.formatOnlineInfo(info)
        loginSwitch.setOn(true, animated: true)
    }
    
    func updateOfflineStatus(prompt: String) {
        status = prompt
        data = "--/--"
        loginSwitch.setOn(false, animated: true)
    }
}
