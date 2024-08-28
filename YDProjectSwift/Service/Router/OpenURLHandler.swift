//
//  OpenURLHandler.swift
//  YDProjectSwift
//
//  Created by 王远东 on 2024/4/10.
//

import Foundation
import UIKit

let ouh = OpenURLHandler.share

class OpenURLHandler:NSObject {
    var isSuccess:Bool = false
    var isNeedConfirm:Bool = false
    static let share =  OpenURLHandler()
    var isNeedAlert:Bool = false
    
    static func handler(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.isApp {
            if let str = url.absoluteString.removingPercentEncoding {
                if str.contains("safepay/") {
                    let components = str.components(separatedBy: "?")
                    if let jsonStr = components.last {

                    
                    }
                    return true
                } else {
                    Router.request(url)
                }
            }
           
        }
        return false
    }
}
