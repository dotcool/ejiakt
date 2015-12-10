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


class VideoTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating,HttpProtocol {
    
    var albums:[Album] = []
    
    var searchResults:[Album] = []
    
    var fetchResultsController:NSFetchedResultsController!
    var loadMore:UIButton?
    var searchController:UISearchController!
    
    var eHttp:HttpController = HttpController() //http基础类
    var imageCache=Dictionary<String,UIImage>()
    var mPage:Int64 = 1 //控制分页的游标
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 80.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        /********************************UISearchBar**********************************************/
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.sizeToFit()
        searchController.searchBar.tintColor = UIColor.whiteColor()
        // searchController.searchBar.barTintColor = UIColor(red: 231.0/255.0, green: 95.0/255.0, blue: 53.0/255.0, alpha: 0.3)
        // searchController.searchBar.prompt = "Quick Search"
        searchController.searchBar.placeholder = NSLocalizedString("搜索视频专辑", comment: "搜索你想要的视频")
        
        tableView.tableHeaderView = searchController.searchBar
        setupLoadMoreButton()
        
        
        definesPresentationContext = true
        
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        
        /********************************从CoreData中获取数据**********************************************/
        eHttp.delegate=self
        eHttp.onSearch(REQ_ALBUM_LIST_TOP+"/"+String(mPage)+"/20")
        
    }
    
    func setupLoadMoreButton()
    {
        self.loadMore = UIButton(type: UIButtonType.Custom) as? UIButton
        self.loadMore!.frame = CGRectMake(0,0,50,40)
        self.loadMore?.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        self.loadMore?.setTitle("加载更多", forState: UIControlState.Normal)
        self.loadMore!.tag = 100
        self.loadMore!.userInteractionEnabled = true
        self.loadMore?.addTarget(self, action: "loadMoreButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        tableView.tableFooterView =  self.loadMore
    }
    
    func loadMoreButtonClick()
    {
        print("loadMoreButtonClick")
        mPage=mPage+1
        eHttp.onSearch(REQ_ALBUM_LIST_TOP+"/"+String(mPage)+"/20")
        
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
    
    
    // 检索过滤
    func filterContentSearchText(searchText:String){
        searchResults = albums.filter({ ( album: Album) -> Bool in
            let nameMatch = album.name.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            let locationMatch = album.description.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return nameMatch != nil || locationMatch != nil
        })
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController){
        let searchText = searchController.searchBar.text
        filterContentSearchText(searchText!)
        tableView.reloadData()
    }
    

    func didRecieveResults(results:NSDictionary,url:String){
        if (results.objectForKey("data") != nil) {
            let arrays =  results.objectForKey("data") as! NSArray
            for dict in arrays {
                let album:Album = Album()
                if(dict.valueForKey("affix") !== NSNull()){
                    album.affix = dict.valueForKey("affix") as! String
                }
                if(dict.valueForKey("author") !== NSNull()){
                    album.author = getNotAndroid(dict.valueForKey("author") as! String)
                }
                if(dict.valueForKey("createTime") !== NSNull()){
                    album.createTime = dict.valueForKey("createTime") as! String
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
        if searchController.active {
            tableView.tableFooterView?.hidden=true
            return searchResults.count
        }else {
            tableView.tableFooterView?.hidden=false
            return albums.count
        }
    }

    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if searchController.active {
            
            return false
        }else {
            
            return false
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


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomTableViewCell
        let album = (searchController.active) ? searchResults[indexPath.row] : albums[indexPath.row]
        cell.nameLabel.text = getNotAndroid(album.name)
        cell.typeLabel.text = getNotAndroid(album.description)
        cell.locationLabel.text = getNotAndroid(album.author)
        cell.thumbnailImageView.image=UIImage(named:"app_logo.png")
        let image=self.imageCache[album.defaultCover] as UIImage!
        if (image == nil){
            let imgURL:NSURL=NSURL(string:album.defaultCover)!
            let request:NSURLRequest=NSURLRequest(URL:imgURL)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response:NSURLResponse?,data:NSData?,error:NSError?)->Void in
                if(data != nil){
                    let img=UIImage(data:data!)
                    cell.thumbnailImageView.image=img
                    self.imageCache[album.defaultCover]=img
                }
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
            let album = (searchController.active) ? searchResults[indexPath.row] : albums[indexPath.row]
            destinationController.album = album
        }
    }
    
    // unwind segue
    
    @IBAction func unwindToHomeScreen(segue:UIStoryboardSegue) {
        
    }
    
}
