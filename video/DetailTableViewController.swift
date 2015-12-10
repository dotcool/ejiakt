//
//  DetailViewController.swift
// video
//
//  Created by scott on 14-11-1.
//  Copyright (c) 2014年 scott. All rights reserved.
//

import UIKit

class DetailTableViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,HttpProtocol {
    
    
    @IBOutlet var tableView: UITableView!
    
    var album:Album!
    
    var videos:[Video] = []

    var imageCache=Dictionary<String,UIImage>()

    var eHttp:HttpController = HttpController()

    
    @IBOutlet weak var albumTitle: UILabel!
 
    @IBOutlet weak var albumAuthor: UILabel!

    @IBOutlet weak var albumCreate: UILabel!
    
    
    @IBOutlet weak var albumCost: UILabel!
    
    @IBOutlet weak var albumeDscription: UITextView!


    var nowIndex:Int = 0
    
    // MARK: - UIStoryboardSegue
    @IBAction func close(segue:UIStoryboardSegue){
        
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDescription()
       
        self.tableView.estimatedRowHeight = 80.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)

        eHttp.delegate=self
        eHttp.onSearch(REQ_ALBUM_VIDEO_LIST+String(album.id))

    }
    
    func getNotWindowsPhone(temp:String) -> String{
        var dest = temp.stringByReplacingOccurrencesOfString("Windows", withString: "C#")
        if(temp != dest){
            return dest
        }else {
            dest = temp.stringByReplacingOccurrencesOfString("windows", withString: "c#")
            if(dest != temp){
                return dest
            }else{
                return dest
            }
            
        }
    }
    
    
    func getNotAndroid(temp:String) -> String{
        var dest = temp.stringByReplacingOccurrencesOfString("android", withString: "java")
        if(temp != dest){
            
            
            return getNotWindowsPhone(dest)
        }else {
            dest = temp.stringByReplacingOccurrencesOfString("Android", withString: "java")
            if(dest != temp){
                return getNotWindowsPhone(dest)
            }else{
                return getNotWindowsPhone(dest)
            }
            
        }
    }

    func didRecieveResults(results:NSDictionary,url:String){
        if results.objectForKey("data") != nil {
            let arrays =  results.objectForKey("data") as! NSArray
            for dict in arrays {
                let video:Video = Video()
                video.type = getNotAndroid(dict.valueForKey("type") as! String)
                video.author = getNotAndroid(dict.valueForKey("author") as! String)
                video.cover = dict.valueForKey("cover") as! String
                video.description =  getNotAndroid(dict.valueForKey("description") as! String)
                video.name  =  getNotAndroid(dict.valueForKey("name") as! String)
                
                video.id = dict.valueForKey("id") as! Int
                video.playCost = dict.valueForKey("playCost") as! Int
                video.tags = dict.valueForKey("tags") as! String
                video.album = album
                videos.append(video)
            }
            tableView.reloadData()
        }
    }

    func setupDescription(){
        albumTitle.text = album.name;
        albumAuthor.text = "作者："+album.author;
        albumCreate.text = "创建时间："+album.createTime;
        albumCost.text = "播放消耗："+String(album.playCost);
        albumeDscription.text = "简介："+album.description;
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    

    
    // MARK: - tableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! DetailTableViewCell
        let video:Video = videos[indexPath.row]
        cell.backgroundColor = UIColor.clearColor()
        cell.titleLabel.text = video.name
        
        return cell
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showVideo" {
            let destinationController = segue.destinationViewController as! PlayerController
            //destinationController.hidesBottomBarWhenPushed = true
            let indexPath = tableView.indexPathForSelectedRow!
            let video:Video = videos[indexPath.row]
            destinationController.video = video
        }else if segue.identifier == "searchRelative" {
            let destinationController = segue.destinationViewController as! RelativeAlbumController
            destinationController.album = album
        }
    }
   
}
