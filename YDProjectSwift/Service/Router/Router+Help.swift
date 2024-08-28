//
//  Router+Help.swift
//  YDProjectSwift
//
//  Created by 王远东 on 2024/8/28.
//

import Foundation

extension Router {
    static func getParametersWith(urlStr: String?) -> [String: Any]? {
        if let str = urlStr {
            let prefixStr = "ydclass://project?"
            if str.hasPrefix(prefixStr) {
                if let paUrl = str.components(separatedBy: prefixStr).last {
                    var handleUrl = paUrl
                    var json: String? = nil
                    if paUrl.contains("json=") {
                        let list = paUrl.components(separatedBy: "json=")
                        if let firstUrl = list.first {
                            handleUrl = firstUrl
                        }
                        
                        if let lastUrl = list.last {
                            json = lastUrl
                        }
                    }
                    
                    let list = handleUrl.components(separatedBy: "&")
                    var parmerDic = [String: Any]()
                    for item in list {
                        let itemList = item.components(separatedBy: "=")
                        if let key = itemList.first , let value = itemList.last {
                            if key.count > 0 {
                                parmerDic[key] = value
                            }
                        }
                    }
                    
                    var pageName = ""
                    if let method = parmerDic["method"] as? String, method.count > 0 {
                        pageName = method
                    }
                    
                    if let page = parmerDic["page"] as? String, page.count > 0 {
                        pageName = page
                    }
                    
                    parmerDic.updateValue(pageName, forKey: "pageName")
                    
                    if let jsonContent = json {
                        parmerDic.updateValue(jsonContent, forKey: "json")
                    }
                    
                    return parmerDic
                }
            }
        }
        return nil
    }
    
    static func checkUrlForLogin(urlStr: String) -> Bool {
        if urlStr.hasPrefix(kRouterPrefix) {
            if let pa = self.getParametersWith(urlStr: urlStr) {
                if let pageName = pa["pageName"] as? String, pageName.isEmpty == false {
                    let noNeedLoginPageArray: [String] = ["openWechatMini"]
                    return !(noNeedLoginPageArray.contains(pageName))
                }
            }
            return true
        }
        
        if urlStr.hasPrefix("http") {
            if urlStr.contains("test1") {
                return true
            }
            
            if urlStr.contains("test2") {
                return true
            }
        }
        return false
    }
}
