//
//  LoginController.swif
// video
//
//  Created by scott on 14-10-31.
//  Copyright (c) 2014年 scott. All rights reserved.
//

import UIKit
import CoreData
import Foundation


class LoginController: UIViewController, HttpProtocol {
      var eHttp:HttpController = HttpController() //http基础类
    var imageCache=Dictionary<String,UIImage>()
    
    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var loginBtn: UIButton!

    @IBOutlet weak var usernameEditText: UITextField!
    
    @IBOutlet weak var passwordEditText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .Plain, target: nil, action: nil)
        /**************************设置登陆事件**************************/
        loginBtn.addTarget(self, action: "loginAction", forControlEvents: UIControlEvents.TouchUpInside)
        eHttp.delegate=self
    }
   
    func alert(msg:String){
        let alertController = UIAlertController(title: "提示", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "关闭", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func loginAction(){
        if(usernameEditText.text == ""){
            alert("用户名不能为空")
        }else if (passwordEditText.text == ""){
            alert("密码为空")
        }else{
            var param = NSString(format: "username=%@&&password=%@", usernameEditText.text!, passwordEditText.text!)
            eHttp.onPost(NORMAL_LOGIN_URL,param: param as String)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.hidesBarsOnSwipe = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        /********************************UIPageViewController**********************************************/
        let defaults = NSUserDefaults.standardUserDefaults()
        let hasViewedWalkthrough = defaults.boolForKey("hasViewedWalkthrough")
        if hasViewedWalkthrough == false {
            if let pageViewController = storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as? PageViewController {
                self.presentViewController(pageViewController, animated: false, completion: nil)
            }
        }
    }
    func goBack(){
       self.navigationController?.popViewControllerAnimated(true)
    }
  
    func didRecieveResults(results:NSDictionary,url:String){
        if(url == NORMAL_LOGIN_URL){
            if (results.objectForKey("code")as! Int != 200){
                alert("登陆失败请重试")
            }else if (results.objectForKey("data") != nil) {
                let data =  results.objectForKey("data") as! NSDictionary
                let userInfo:UserInfo = UserInfo()
                userInfo.id = data.valueForKey("id") as! Int
                userInfo.ingot = data.valueForKey("ingot") as! Int
                userInfo.pay = data.valueForKey("pay") as! Float
                userInfo.score = data.valueForKey("score") as! Int
                NSUserDefaults.standardUserDefaults().setObject(usernameEditText.text, forKey: "username")
                NSUserDefaults.standardUserDefaults().setObject(userInfo.ingot, forKey: "ingot")
                NSUserDefaults.standardUserDefaults().setObject(userInfo.score, forKey: "score")
                goBack()
            }
        }
    }
    
    
}
