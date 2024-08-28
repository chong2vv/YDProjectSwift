//
//  URL+YD.swift
//  YDProjectSwift
//
//  Created by 王远东 on 2024/4/8.
//

import Foundation

extension URL {
    var isApp: Bool {
        guard let scheme = self.scheme else {
            return false
        }
        if scheme == "ydclass" {
            return true
        }
        return false
    }
    var isOther: Bool {
        guard let scheme = self.scheme else {
            return false
        }
        if !scheme.contains("http") {
            return true
        }
        return false
    }
    
    var isAli: Bool {
        guard let scheme = self.scheme else {
            return false
        }
        if scheme == "alipay" || scheme ==  "alipays" {
            return true
        }
        return false
    }
    
    func queryParse() -> [String:Any]?{
        guard let string = query else {
            return nil
        }
        var paramers = [String:Any]()
        var json:String? = nil
        var first:String = ""
        if string.contains("json=") {
             let list = string.components(separatedBy: "json=")
            json = list.last
            if let str = list.first {
                first = str
            }
        }
        
        if string.contains("url=") {
            let list = string.components(separatedBy: "url=")
            if let url = list.last {
                paramers["url"] = url
            }
            if let str = list.first {
                first = str
            }
        }
        
        if !string.contains("url=") && !string.contains("json=") {
            first = string
        }
        
        let list = first.components(separatedBy: "&")
        if list.count == 0 {
            return nil
        }
        for item in list {
            let itemList = item.components(separatedBy: "=")
            if let key = itemList.first , let value = itemList.last {
                paramers[key] = value
            }
        }
        if let json = json?.removingPercentEncoding {
            paramers["json"] = json
        }
        return paramers
    }
}
