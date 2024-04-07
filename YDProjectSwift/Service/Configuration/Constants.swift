//
//  Constants.swift
//  YDProjectSwift
//
//  Created by 王远东 on 2024/4/2.
//

import Foundation
import Hue
import UIKit

enum DEVENV {
    case DEVELOP // 开发环境
    case PREVIEW // 预发布
    case RELEASE // 正式环境
}

// 判断当前是否debug编译模式
#if DEBUG
let IS_DEBUG = true
#else
let IS_DEBUG = false
#endif

// MARK: HTTP
let kBaseURLDev = "https://www.chong2vv.com/api"
let kBaseURLRel = "https://www.chong2vv.com/api"
let kBaseURLTest = "https://www.chong2vv.com/api"
let kBaseURLPre = "https://www.chong2vv.com/api"

// MARK: H5HOST
let kBaseHOSTDev = "https://www.chong2vv.com/h5"
let kBaseHOSTRel = "https://www.chong2vv.com/h5"
let kBaseHOSTTest = "https://www.chong2vv.com/h5"
let kBaseHOSTPre = "https://www.chong2vv.com/h5"


// MARK: Screen size
let kScreenBounds = UIScreen.main.bounds
let kScreenSize = kScreenBounds.size
let kScreenWidth = min(kScreenSize.width, kScreenSize.height)
let kScreenHeight = max(kScreenSize.width, kScreenSize.height)
