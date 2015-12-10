//
//  RestaurantTableViewController.swift
// video
//
//  Created by scott on 14-10-31.
//  Copyright (c) 2014年 scott. All rights reserved.
//

import UIKit
import CoreData
import Foundation


class RelativeAlbumController: UITableViewController, NSFetchedResultsControllerDelegate,HttpProtocol {
    
    var albums:[Album] = []
    var album:Album = Album()

    
    var eHttp:HttpController = HttpController()
    var imageCache=Dictionary<String,UIImage>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 80.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)

        
        
        definesPresentationContext = true
        
        /********************************从CoreData中获取数据**********************************************/
        eHttp.delegate=self
        let temlUrl:String = REQ_ALBUM_RELATED_LIST+"/"+album.affix
        eHttp.onSearch( temlUrl + "/" + String(album.id))
        
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
                let album:Album = Album()
                if(dict.valueForKey("affix") !== NSNull()){
                    album.affix = dict.valueForKey("affix") as! String
                }
                if(dict.valueForKey("author") !== NSNull()){
                    album.author = getNotAndroid(dict.valueForKey("author")as! String)
                }
                if(dict.valueForKey("createTime") !== NSNull()){
                    album.createTime = dict.valueForKey("createTime")as! String
                }
                if(dict.valueForKey("cover") !== NSNull()){
                    album.defaultCover = dict.valueForKey("cover") as! String
                }else if ( dict.valueForKey("defaultCover") !== ""){
                    album.defaultCover = dict.valueForKey("defaultCover") as! String
                }
                if(dict.valueForKey("description") !== NSNull()){
                    album.description = getNotAndroid(dict.valueForKey("description") as! String)
                }
                if(dict.valueForKey("id") !== NSNull()){
                    album.id = dict.valueForKey("id") as! Int
                }
                if(dict.valueForKey("name") !== NSNull()){
                    album.name = getNotAndroid(dict.valueForKey("name") as! String)
                }
                if(dict.valueForKey("playCost") !== NSNull()){
                    album.playCost = dict.valueForKey("playCost") as! Int
                }
                if(dict.valueForKey("tags") !== NSNull()){
                    album.tags = dict.valueForKey("tags") as! String
                }
                albums.append(album)
            }
            tableView.reloadData()
        }
    }
    
    
    // MARK: - tableView
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
            return false
    }
    
    
      
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomTableViewCell
        let album = albums[indexPath.row]
        cell.nameLabel.text = getNotAndroid(album.name)
        cell.typeLabel.text = getNotAndroid(album.description)
        cell.locationLabel.text = getNotAndroid(album.author)
        cell.thumbnailImageView.image=UIImage(named:"cafelore.jpg")
        let image=self.imageCache[album.defaultCover] as UIImage!
        if (image == nil){
            let imgURL:NSURL=NSURL(string:album.defaultCover)!
            let request:NSURLRequest=NSURLRequest(URL:imgURL)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response:NSURLResponse?,data:NSData?,error:NSError?)->Void in
                let img=UIImage(data:data!)
                cell.thumbnailImageView.image=img
                self.imageCache[album.defaultCover]=img
                
            })
        }else {
            cell.thumbnailImageView.image=image
        }
        cell.thumbnailImageView.layer.cornerRadius = cell.thumbnailImageView.frame.size.width / 2
        cell.thumbnailImageView.clipsToBounds = true
        return cell
    }
    
    // MARK: - nav
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showVideoDetail" {
            let destinationController = segue.destinationViewController as! DetailTableViewController
            //destinationController.hidesBottomBarWhenPushed = true
            let indexPath = tableView.indexPathForSelectedRow!
            let album = albums[indexPath.row]
            destinationController.album = album
        }
    }
    
    // unwind segue
    
    @IBAction func unwindToHomeScreen(segue:UIStoryboardSegue) {
        
    }
    
}
