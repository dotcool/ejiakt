//
//  LoginWebViewController.swift
//  video
//
//  Created by dotcool on 15/5/8.
//  Copyright (c) 2015年 dotcool. All rights reserved.
//

import UIKit

class LoginWebViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://www.ejiakt.com/register/")!))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
