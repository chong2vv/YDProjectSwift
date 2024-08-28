//
//  NSObject+YD.swift
//  YDProjectSwift
//
//  Created by 王远东 on 2024/4/10.
//

import Foundation
import WebKit

extension NSObject
{
    /// 返回className
    var ydClassName: String {
        get{
            let name =  type(of: self).description()
            if (name.contains(".")) {
                let nameArray = name.components(separatedBy: ".")
                if nameArray.count > 1 {
                    return nameArray[1]
                }
            }
            return name
        }
    }
    
    /// 返回类名
    static var className: String {
        return String(describing: self)
    }
    
    
    func clearWebviewCache() {
        let dateFrom: NSDate = NSDate.init(timeIntervalSince1970: 0)
        if #available(iOS 11.3, *) {
            let types:Set = [WKWebsiteDataTypeMemoryCache,WKWebsiteDataTypeDiskCache,WKWebsiteDataTypeFetchCache,WKWebsiteDataTypeServiceWorkerRegistrations]
            WKWebsiteDataStore.default().removeData(ofTypes: types, modifiedSince: dateFrom as Date) {
                print("清空缓存完成")
            }
            
        } else {
            let types:Set = [WKWebsiteDataTypeMemoryCache,WKWebsiteDataTypeDiskCache]
            WKWebsiteDataStore.default().removeData(ofTypes: types, modifiedSince: dateFrom as Date) {
                print("清空缓存完成")
            }
        }
        
        URLCache.shared.removeAllCachedResponses()
    }
    
    func closeWebviewLocalStorage() {
        let dateFrom: NSDate = NSDate.init(timeIntervalSince1970: 0)
        if #available(iOS 11.3, *) {
            let types:Set = [WKWebsiteDataTypeMemoryCache,WKWebsiteDataTypeDiskCache,WKWebsiteDataTypeFetchCache,WKWebsiteDataTypeServiceWorkerRegistrations,WKWebsiteDataTypeLocalStorage]
            WKWebsiteDataStore.default().removeData(ofTypes: types, modifiedSince: dateFrom as Date) {
                print("清空缓存完成")
            }
            
        } else {
            let types:Set = [WKWebsiteDataTypeMemoryCache,WKWebsiteDataTypeDiskCache,WKWebsiteDataTypeLocalStorage]
            WKWebsiteDataStore.default().removeData(ofTypes: types, modifiedSince: dateFrom as Date) {
                print("清空缓存完成")
            }
        }
        URLCache.shared.removeAllCachedResponses()
    }
}

