//
//  UIFont+YD.swift
//  YDProjectSwift
//
//  Created by 王远东 on 2024/4/10.
//

import Foundation
import UIKit

public extension UIFont {
    
    static func YDFont(fontSize: CGFloat) -> UIFont {
        return self.pingfangRegularFont(fontSize)
    }
    
    static func YDBoldFont(fontSize: CGFloat) -> UIFont {
        return UIFont.boldSystemFont(ofSize: fontSize)
    }
    
    /// 平方常规
    static func pingfangRegularFont(_ fontSize: CGFloat) -> UIFont {
        guard let font = UIFont(name: "PingFangSC-Regular", size: fontSize)  else {
            return UIFont.systemFont(ofSize: fontSize)
        }
        return font
    }
    
    /// 平方中粗体
    static func pingfangSemiboldFont(_ fontSize: CGFloat) -> UIFont {
        guard let font = UIFont(name: "PingFangSC-Semibold", size: fontSize)  else {
            return UIFont.systemFont(ofSize: fontSize)
        }
        return font
    }
    
    /// 平方中黑体
    static func pingfangMediumFont(_ fontSize: CGFloat) -> UIFont {
        guard let font = UIFont(name: "PingFangSC-Medium", size: fontSize)  else {
            return UIFont.systemFont(ofSize: fontSize)
        }
        return font
    }
    
    /// DIN_Alternate_Bold
    static func DINAlternateBoldFont(_ fontSize: CGFloat) -> UIFont {
        guard let font = UIFont(name: "DIN Alternate", size: fontSize)  else {
            return UIFont.systemFont(ofSize: fontSize)
        }
        return font
    }
    
    /// 华文楷体
    static func STKaiti(_ fontSize: CGFloat) -> UIFont {
        guard let font = UIFont(name: "STKaiti", size: fontSize)  else {
            return UIFont.systemFont(ofSize: fontSize)
        }
        return font
    }
}

