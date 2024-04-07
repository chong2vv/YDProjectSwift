//
//  YDAppConfig.swift
//  YDProjectSwift
//
//  Created by 王远东 on 2024/4/2.
//

import Foundation
import KeychainSwift
import AppTrackingTransparency
import YDUtilKit

let appname:String = "YDProject"

var appversion:String {
    guard let ver = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
        return "1.0"
    }
    return ver
}

var appdisplayName: String {
    guard let name = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String else {
        return "YDProject"
    }
    return name
}

var buildCode:String {
    guard let code = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
        return "1"
    }
    return code
}

var systemVersion:String {
    return UIDevice.current.systemVersion
}

var systemName = "iOS"

let deviceModel = UIDevice.current.model

let deviceName = UIDevice.current.machineModelName ?? ""

//MARK: ua
var userAgent:String {
    var channel = "38"
    let uaStr = appname + "/" + appversion + "/" + buildCode + "/" + channel + "/" + "(" + systemVersion + "/" + deviceName + ")"
    return uaStr
}

var deviceId:String {
    return AppConfig.shared.udid
}

var ratio:String {
    return "\(kScreenWidth)x\(kScreenHeight)"
}

var market:String {
    return "AppStore"
}

class AppConfig {
    static let shared = AppConfig()
    
    lazy var udid: String = {
        let key = "com.ydproject.udid"
        let keychain = KeychainSwift()
        keychain.synchronizable = true
        if let udid = keychain.get(key) {
            return udid
        }
        let udid = UUID().uuidString
        keychain.set(udid, forKey: key)
        return udid
    }()
}
