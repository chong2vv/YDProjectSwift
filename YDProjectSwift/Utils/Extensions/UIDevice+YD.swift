//
//  UIDevice+YD.swift
//  YDProjectSwift
//
//  Created by 王远东 on 2024/4/8.
//

import Foundation
import UIKit

let MNotSet = CGFloat.greatestFiniteMagnitude
let ScreenSize = UIScreen.main.bounds.size
let ScreenWidth = min(ScreenSize.width, ScreenSize.height)
let ScreenHeight = max(ScreenSize.width, ScreenSize.height)

enum YDDeviceType {
    case YDiPad
    case YDiPhone
    case YDiPod
    case YDUnknown
    static func YDCurrentDeviceType() -> YDDeviceType {
        let deviceType = UIDevice.current.model
        switch deviceType {
        case "iPad":
            return YDiPad
        case "iPhone":
            return YDiPhone
        case "iPod touch":
            return YDiPod
        default:
            return YDUnknown
        }
    }
}

let YDIsiPad = (YDDeviceType.YDCurrentDeviceType() == .YDiPad)
let YDIsiPhone = (YDDeviceType.YDCurrentDeviceType() == .YDiPhone)

//MARK: safe area
let YDSafeAreaInsets = {() -> UIEdgeInsets in
    guard #available(iOS 11.0, *) else {
        return .zero
    }
    if let appDelegate = UIApplication.shared.delegate as? SceneDelegate {
        if let keyWindow = appDelegate.window {
            return keyWindow.safeAreaInsets
        }
    }
    return .zero
}

//FIXME: 因为目前只支持竖屏所以safeArea是不变的取一次就可以；如果后边支持横屏的话这里不能用let常量；
let YDSafeTop = YDSafeAreaInsets().top
let YDSafeBottom = YDSafeAreaInsets().bottom
let YDTopH: CGFloat = (YDSafeTop == 0) ? (20) : YDSafeTop
let YDBottomBarHeight: CGFloat = YDSafeBottom + 49

/// 根据当前机型返回对应传入的参数(iPad/iPhone)
/// - Parameter iPhone: iPhone参数
/// - Parameter iPad: iPad参数
func YDDeviceValue<T>(iPhone: T, iPad: T, smallScreen: T? = nil) -> T {
    if YDIsiPad {
        return iPad
    } else if YDIsiPhone {
        return iPhone
    } else if ScreenWidth == 320, let small = smallScreen {
        return small
    }
    return iPhone
}

/// 系统版本号
var gSystemVersion: Float {
    if let version = Float(UIDevice.current.systemVersion) {
        return version
    }
    return 0.0
}

public extension UIDevice {
    
    var ai_modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        switch identifier {
        case "iPod1,1":  return "iPod Touch 1"
        case "iPod2,1":  return "iPod Touch 2"
        case "iPod3,1":  return "iPod Touch 3"
        case "iPod4,1":  return "iPod Touch 4"
        case "iPod5,1":  return "iPod Touch (5 Gen)"
        case "iPod7,1":   return "iPod Touch 6"
        case "iPod9,1":   return "7th Gen iPod"
            
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":  return "iPhone 4"
        case "iPhone4,1":  return "iPhone 4s"
        case "iPhone5,1":   return "iPhone 5"
        case  "iPhone5,2":  return "iPhone 5 (GSM+CDMA)"
        case "iPhone5,3":  return "iPhone 5c (GSM)"
        case "iPhone5,4":  return "iPhone 5c (GSM+CDMA)"
        case "iPhone6,1":  return "iPhone 5s (GSM)"
        case "iPhone6,2":  return "iPhone 5s (GSM+CDMA)"
        case "iPhone7,2":  return "iPhone 6"
        case "iPhone7,1":  return "iPhone 6 Plus"
        case "iPhone8,1":  return "iPhone 6s"
        case "iPhone8,2":  return "iPhone 6s Plus"
        case "iPhone8,4":  return "iPhone SE"
        case "iPhone9,1","iPhone9,3":  return "iPhone 7"
        case "iPhone9,2","iPhone9,4":  return "iPhone 7 Plus"
        case "iPhone10,1","iPhone10,4":   return "iPhone 8"
        case "iPhone10,2","iPhone10,5":   return "iPhone 8 Plus"
        case "iPhone10,3","iPhone10,6":   return "iPhone X"
            
        case "iPhone11,8":   return "iPhone XR"
        case "iPhone11,2":   return "iPhone XS"
        case "iPhone11,4","iPhone11,6":   return "iPhone XS Max"
            
        case "iPhone12,1":   return "iPhone 11"
        case "iPhone12,3":   return "iPhone 11 Pro"
        case "iPhone12,5":   return "iPhone 11 Pro Max"
        case "iPhone12,8":   return "iPhone SE 2nd Gen"
            
        case "iPad1,1":   return "iPad"
        case "iPad1,2":   return "iPad 3G"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":   return "iPad 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":  return "iPad Mini"
        case "iPad3,1", "iPad3,2", "iPad3,3":  return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":   return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":   return "iPad Air"
        case "iPad4,4", "iPad4,5", "iPad4,6":  return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":  return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":  return "iPad Mini 4"
        case "iPad5,3", "iPad5,4":   return "iPad Air 2"
        case "iPad6,3", "iPad6,4":  return "iPad Pro 9.7"
        case "iPad6,7", "iPad6,8":  return "iPad Pro 12.9"
        case "iPad6,11", "iPad6,12":  return "iPad (2017)"
        case "iPad7,1", "iPad7,2":  return "iPad Pro (12.9 inch)"
        case "iPad7,3", "iPad7,4":  return "iPad Pro (10.5 inch)"
        case "iPad7,5", "iPad7,6":  return "iPad(6th gen)"
        case "iPad8,1", "iPad8,2","iPad8,3","iPad8,4":  return "iPad Pro 3rd Gen(11 inch)"
        case "iPad8,5", "iPad8,6","iPad8,7","iPad8,8":  return "iPad Pro 3rd Gen(12.9 inch)"
        case "iPad11,1", "iPad11,2","iPad11,3","iPad11,4":  return "iPad Air 3rd Gen"
            
        case "AppleTV2,1":  return "Apple TV 2"
        case "AppleTV3,1","AppleTV3,2":  return "Apple TV 3"
        case "AppleTV5,3":   return "Apple TV 4"
            
        case "i386", "x86_64":   return "Simulator"
        default:  return identifier
        }
    }
    
    var isIPad4: Bool {
        return "iPad 4" == ai_modelName
    }
}

