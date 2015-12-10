//
//  Video.swift
//  video
//
//  Created by dotcool on 15/4/14.
//  Copyright (c) 2015年 dotcool. All rights reserved.
//

import Foundation
import CoreData

class Video {
    let ORDER_FIELDS:[String]=["create_time", "id", "play_times", "total_time",
        "rating", "rating_num"]
    let MAX_RATING:Float = 10.0
    let DEAULT_VIDEO_TYPE:Int = 1
    let QINIU_VIDEO_TYPE:Int = 2
     var id:Int = 0
     var name:String = ""
     var author:String = ""
     var vid:String = ""
     var url:String = ""
     var category:String = ""
     var order:Int = 0
     var playCost:Int = 0
     var downloadCost:Int = 0
     var cover:String = ""
     var image:String = ""
     var description:String = ""
     var tags:String = ""
     var rating:Float = 0.0
     var ratingNum:Int = 0
     var playTimes:Int = 0
     var createTime:String = ""
     var lastTime:String = ""
     var totalTime:Int = 0
     var audit:Bool = false
     var album:Album = Album()
     var recommend:Bool = false
     var affix:String = ""
     var type:String = ""
     var notes:String = ""
    init() {
        
    }
}