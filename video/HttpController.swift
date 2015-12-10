//
//  HttpController.swift
//  video
//
//  Created by dotcool on 15/4/15.
//  Copyright (c) 2015年 dotcool. All rights reserved.
//

import UIKit

protocol HttpProtocol{
    func didRecieveResults(results:NSDictionary,url:String)
}

class HttpController:NSObject{
    
    var delegate:HttpProtocol?
    
    func onSearch(url:String){
        let nsUrl:NSURL!=NSURL(string:url)
        print(url)
        let request:NSURLRequest=NSURLRequest(URL:nsUrl)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response:NSURLResponse?,data:NSData?,error:NSError?)->Void in
            var jsonResult:NSDictionary=NSDictionary()
            if(data==nil){
                self.delegate?.didRecieveResults(jsonResult,url: url)
            } else {
                jsonResult=(try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                self.delegate?.didRecieveResults(jsonResult,url: url)
            }
        })
    }
    func onVideo(url:String){
        let nsUrl:NSURL!=NSURL(string:url)
        print(url)
        let request:NSMutableURLRequest=NSMutableURLRequest(URL:nsUrl)
        request.setValue("ajax", forHTTPHeaderField: "method")
        request.setValue("zh-cn,zh;q=0.5", forHTTPHeaderField: "Accept-Language")
        request.setValue("http://www.ejiakt.com", forHTTPHeaderField: "Referer")
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response:NSURLResponse?,data:NSData?,error:NSError?)->Void in
            var jsonResult:NSDictionary=NSDictionary()
            if ( data==nil ) {
                self.delegate?.didRecieveResults(jsonResult,url: url)
            } else {
                jsonResult=(try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                self.delegate?.didRecieveResults(jsonResult,url: url)
            }
        })
    }
    func onPost(url:String,param:String){
        let request=NSMutableURLRequest(URL: NSURL(string: url)!)
        request.timeoutInterval=6
        request.HTTPMethod="POST"
        request.HTTPBody=NSString(string: param).dataUsingEncoding(NSUTF8StringEncoding)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response:NSURLResponse?,data:NSData?,error:NSError?)->Void in
            var jsonResult:NSDictionary=NSDictionary()
            if ( data==nil ) {
                self.delegate?.didRecieveResults(jsonResult,url: url)
            } else {
                jsonResult=(try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                self.delegate?.didRecieveResults(jsonResult,url: url)
            }
        })

    }

}
