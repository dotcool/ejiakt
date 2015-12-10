//
//  PageViewController.swift
// video
//
//  Created by scott on 14-11-4.
//  Copyright (c) 2014年 scott. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource {

    var pageHeadings = ["免费学习", "高新技术", "学以致用"]
    var pageImages = ["spider1", "spider2", "spider3"]
    var pageSubHeadings = ["E家课堂是一个免费的在线学习平台提供优质的教学视频教程", "E家课堂提供了目前炙手可热的it技术如前端开发技术等等", "我们针对不同内容提供了大量的实战系列视频提高学习的能力"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        if let startingViewController = self.viewControllerAtIndex(0){
            setViewControllers([startingViewController], direction: .Forward, animated: true, completion: nil)
        }
    }

    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PageContentViewController).index
        index--
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PageContentViewController).index
        index++
        return self.viewControllerAtIndex(index)
    }
    
    
    func viewControllerAtIndex(index: Int) -> PageContentViewController? {
        if index == NSNotFound || index < 0 || index >= self.pageHeadings.count {
            return nil
        }
        if let pageContentViewController = storyboard?.instantiateViewControllerWithIdentifier("PageContentViewController") as? PageContentViewController {
            pageContentViewController.imageFile = pageImages[index]
            pageContentViewController.heading = pageHeadings[index]
            pageContentViewController.subHeading = pageSubHeadings[index]
            pageContentViewController.index = index
            return pageContentViewController
        }
        return nil
    }
    
    
    
    func forward(index : Int){
        if let nextViewController = self.viewControllerAtIndex(index+1){
            setViewControllers([nextViewController], direction: .Forward, animated: true, completion: nil)
        }
    }
    
    
    
    // MARK: - Adding Default Page Indicator
    
    /*
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pageHeadings.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        if let pageViewController = storyboard?.instantiateViewControllerWithIdentifier("PageContentViewController") as? PageContentViewController {
            return pageViewController.index
        }
        return 0
    }*/
    
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
