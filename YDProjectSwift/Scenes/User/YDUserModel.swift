//
//  YDUserModel.swift
//  YDProjectSwift
//
//  Created by 王远东 on 2024/4/7.
//

import Foundation

class YDUserContainerModel: YDHandyJSON {
    
    var user: YDUserModel?
    var token = ""
    var channel = ""
    var id:String = ""
    var sendId:String = ""
    var mobile:String = ""
    
    /// 用户是否已经完善资料
    var profile: Bool = false
    
    /// login登录 register注册
    var type: String = ""
    required init() {}
}

class YDUserModel: YDHandyJSON {
    var username = ""
    var head = ""
    var age = ""
    var uid = ""
    required init() {}
}
