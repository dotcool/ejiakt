//
//  DetailViewController.swift
// video
//
//  Created by scott on 14-11-1.
//  Copyright (c) 2014年 scott. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class PlayerController: AVPlayerViewController,HttpProtocol {
    
    

    
    var video:Video!

    
    var imageCache=Dictionary<String,UIImage>()
    
    var eHttp:HttpController = HttpController()
 
    
    // MARK: - UIStoryboardSegue
    @IBAction func close(segue:UIStoryboardSegue){
        
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        eHttp.delegate=self
        eHttp.onVideo(REQ_VIDEO_PLAY_URL + "/" + String(video.id))
        
    }
    func didRecieveResults(results:NSDictionary,url:String){
        if results.objectForKey("data") != nil {
            self.willAnimateRotationToInterfaceOrientation(UIInterfaceOrientation.LandscapeRight, duration: 100)
            self.videoGravity = AVLayerVideoGravityResizeAspect
            if(results.valueForKey("code") as! NSNumber == 200){
                let nsUrl:NSURL!=NSURL(string:results.objectForKey("data") as! String)
                self.player = AVPlayer(URL: nsUrl)
                self.player!.play()
            }else{
                self.viewWillDisappear(true)
            }
        }
    }
    
  
}
