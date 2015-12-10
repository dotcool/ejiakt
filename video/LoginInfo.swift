//
//  LoginInfo.swift
//  video
//
//  Created by dotcool on 15/4/14.
//  Copyright (c) 2015年 dotcool. All rights reserved.
//
import Foundation

class LoginInfo {
    let CODE_SUCCEED:Int = 1
    let PASSWORD_IS_WRONG:Int = -100
    let ACCOUNT_EXCEPTION:Int = -1005
    
     var access_token:String = ""
     var expires_in:String = ""
     var expiresTime:Int = 0
     var uid:String = ""
     var userInfo:UserInfo = UserInfo()
     var loginType:Int = 0
    init() {
        
    }
}