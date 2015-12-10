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


class AllCategoryController: UIViewController, NSFetchedResultsControllerDelegate, HttpProtocol
    , UITableViewDelegate, UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate {
    
    var albums:[Album] = []
    
    var searchResults:[Album] = []
    
    var fetchResultsController:NSFetchedResultsController!
    var loadMore:UIButton?
    var searchController:UISearchController!
    
    var eHttp:HttpController = HttpController() //http基础类
    var imageCache=Dictionary<String,UIImage>()
    var mPage:Int64 = 1 //控制分页的游标
    var data:[AffixItem]=[]
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var categoryBtn: UIButton!

    @IBOutlet weak var detailBtn: UIButton!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    var pickerView: UIPickerView!
    var okBtn: UIButton!
    var categoryId: Int = 0
    var currentId: Int = 0
    var detailId: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 80.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        setupLoadMoreButton()
        
        
        definesPresentationContext = true
        
        /******************************设置pickerview********************************************/
        // 初始化 myPickerView
        pickerView = UIPickerView(frame: CGRectMake(0, self.view.frame.height - 150, self.view.frame.width, 150))
        pickerView.delegate = self
        pickerView.dataSource = self
        // 显示选中框，iOS7 以后不起作用
        pickerView.showsSelectionIndicator = false
        pickerView.backgroundColor = UIColor(red: 247/225, green: 247/225, blue: 247/225, alpha: 1)
        self.view.addSubview(pickerView)
        pickerView.hidden = true
        
        okBtn = UIButton(frame: CGRectMake(self.view.frame.width-75, self.view.frame.height - 150, 75, 45))
        okBtn.backgroundColor = UIColor(red: 241/225, green: 142/225, blue: 142/225, alpha: 1)
        okBtn.setTitle("确定", forState:UIControlState.Normal)
        okBtn.hidden = true
        self.view.addSubview(okBtn)
        
        /*******************************设置点击事件***********************************************/
        categoryBtn.addTarget(self, action: "changeCateogry", forControlEvents: UIControlEvents.TouchUpInside)
        detailBtn.addTarget(self, action: "changeDetail", forControlEvents: UIControlEvents.TouchUpInside)
        okBtn.addTarget(self, action: "selectOk", forControlEvents: UIControlEvents.TouchUpInside)
        /********************************从CoreData中获取数据**********************************************/
        eHttp.delegate=self
        eHttp.onSearch(REQ_ALBUM_LIST_URL)
        
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int)->Int {
        if(categoryId == 1){
            return data.count
        }else if(categoryId > 0){
            return data[currentId].affixMap.affix.count
        }else {
            return 0
        }
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if(categoryId == 1){
            currentId = row
            detailId = 0
            return data[row].affixMap.name
        }else if(categoryId > 0){
            detailId  = row
            return data[currentId].affixMap.affix[row].name
        }else {
            return ""
        }
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(row)
    }
    func changeCateogry(){
        categoryId = 1
        pickerView.hidden = false
        okBtn.hidden = false
        self.pickerView.reloadAllComponents()
    }
    func changeDetail(){
        categoryId = 2
        pickerView.hidden = false
        okBtn.hidden = false
        self.pickerView.reloadAllComponents()
    }
    func selectOk(){
        pickerView.hidden = true
        okBtn.hidden = true
        //label 变化
        categoryLabel.text = data[currentId].affixMap.name
        detailLabel.text = data[currentId].affixMap.affix[detailId].name
        mPage = 0
        albums = data[currentId].albums
        self.tableView.reloadData()
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
        self.tableView.tableFooterView =  self.loadMore
    }
    
    func loadMoreButtonClick()
    {
        print("loadMoreButtonClick")
        mPage=mPage+1
        eHttp.onSearch(REQ_ALBUM_AFFIX_URL+self.detailLabel.text!+"/"+String(mPage)+"/20?orderBy=id")
        
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
        if(url == REQ_ALBUM_LIST_URL){
        if (results.objectForKey("data") != nil) {
            let arrays =  results.objectForKey("data") as! NSArray
            for dict in arrays {
                //获取alubumItem
               
                let affixItem:AffixItem = AffixItem()
                let affixMapNs = dict.valueForKey("affixMap") as! NSDictionary
                affixItem.affixMap.name = affixMapNs.valueForKey("name") as! String
                let affixsNs = affixMapNs.valueForKey("affixs") as! NSArray
                for affixNs in affixsNs{
                    let affix:Affix = Affix()
                    
                    let temp = affixNs.valueForKey("value") as! String
                    affix.value = getNotAndroid(temp)
                    
                    let temps = affixNs.valueForKey("name") as! String
                   
                    affix.name = getNotAndroid(temps)

                    affixItem.affixMap.affix.append(affix)
                }
                let albumsNs = dict.valueForKey("albums") as! NSArray
                for albumNs in albumsNs{
                    let album:Album = Album()
                    album.affix = albumNs.valueForKey("affix") as! String
                    album.author = getNotAndroid(albumNs.valueForKey("author") as! String)
                    if(albumNs.valueForKey("cover") !== NSNull()){
                        album.defaultCover = albumNs.valueForKey("cover") as! String
                    }else if(albumNs.valueForKey("defaultCover") !== NSNull()){
                         album.defaultCover = albumNs.valueForKey("defaultCover") as! String
                    }
                    album.createTime = albumNs.valueForKey("createTime") as! String
                    
                    album.id = albumNs.valueForKey("id") as! Int
                    
                    var temp = albumNs.valueForKey("name") as! String
                    
                    album.name = getNotAndroid(temp)

                    temp = albumNs.valueForKey("description") as! String
                    
                    album.description = getNotAndroid(temp)
                    
                    album.playCost = albumNs.valueForKey("playCost") as! Int
                    album.tags = albumNs.valueForKey("tags") as! String
                    affixItem.albums.append(album)
                    
                }
                data.append(affixItem)
            }
            //加载完成设置界面
            if(data.count>0){
                self.albums = data.first!.albums
                self.categoryLabel.text = data.first!.affixMap.name
                self.detailLabel.text = data.first!.affixMap.affix.first?.name
            }
            self.tableView.reloadData()
            self.pickerView.reloadAllComponents()
        }
        }else{
            if (results.objectForKey("data") != nil) {
                let datas =  results.objectForKey("data") as! NSDictionary
                let total = datas.valueForKey("total") as! Int
                let current = datas.valueForKey("current") as! Int
                let data = datas.valueForKey("data") as! NSArray
                if(current == total){
                    self.loadMore?.hidden = true
                }
                for albumNs in data{
                    let album:Album = Album()
                    album.affix = albumNs.valueForKey("affix") as! String
                    album.author = albumNs.valueForKey("author") as! String
                    if(albumNs.valueForKey("cover") !== NSNull()){
                        album.defaultCover = albumNs.valueForKey("cover") as! String
                    }else if(albumNs.valueForKey("defaultCover") !== NSNull()){
                        album.defaultCover = albumNs.valueForKey("defaultCover") as! String
                    }
                    album.createTime = albumNs.valueForKey("createTime") as! String
                    album.description = getNotAndroid(albumNs.valueForKey("description") as! String)
                    
                    album.id = albumNs.valueForKey("id") as! Int
                    album.name = getNotAndroid(albumNs.valueForKey("name") as! String)
                    album.playCost = albumNs.valueForKey("playCost") as! Int
                    album.tags = albumNs.valueForKey("tags") as! String
                    self.albums.append(album)
                }
                 self.tableView.reloadData()
            }
        }
        
    }
    
    

    
    // MARK: - tableView
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
     
    }
    // 此大法是为了滑动单元格时显示UITableViewRowAction
     func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
     func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
            return true
    }
    
    
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CateogryTableViewCell
        let album = albums[indexPath.row]
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
        print(segue.identifier)
        if segue.identifier == "showAllVideoDetail" {
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
