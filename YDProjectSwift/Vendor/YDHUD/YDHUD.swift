//
//  YDHUD.swift
//  YDProjectSwift
//
//  Created by 王远东 on 2024/4/8.
//

import Foundation
import YDSVProgressHUD

class YDHUD {
    static func showLoading() {
        UIViewController.showLoading()
    }
    
    static func dimiss() {
        UIViewController.dismissLoading()
    }
    
    static func showToast(_ string:String) {
        UIViewController.showText(string)
    }
}
