//
//  MemberCenterController.swif
// video
//
//  Created by scott on 14-10-31.
//  Copyright (c) 2014年 scott. All rights reserved.
//

import UIKit
import CoreData
import Foundation


class MemberCenterController: UIViewController {
    
    @IBOutlet weak var LoginBtn: UIButton!
    
    @IBOutlet weak var userInfoLabel: UILabel!

    @IBOutlet weak var scoreBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoginBtn.addTarget(self, action: "LoginAction", forControlEvents: UIControlEvents.TouchUpInside)
        scoreBtn.hidden = true
    }

    func LoginAction(){
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let tipstr = NSUserDefaults.standardUserDefaults().valueForKey("username") as! String?
        if(tipstr != "" && tipstr != nil){
            userInfoLabel.text = tipstr
        }
      
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "loginView" {
            let destinationController = segue.destinationViewController as! LoginController
            //destinationController.hidesBottomBarWhenPushed = true
            
        }
    }

    
    
}
