//
//  Variables.swift
//  YDProjectSwift
//
//  Created by 王远东 on 2024/4/8.
//

import Foundation

/// 开发环境，修改此值用于指定环境变量
/// 注意：发版时一定要切换到正式环境（.RELEASE）
var dDevEnv: DEVENV? = nil
var gDevEnv: DEVENV {
    if let env = dDevEnv {
        return env
    }
    #if YDProjectSwiftDev
    return .DEVELOP // 开发环境
    #elseif YDProjectSwiftPre
    return .PREVIEW // 预发布环境
    #else
    return .RELEASE // 正式环境（线上包）
    #endif
}

func YDDevEnv<T>(dev: T, pre: T, rel: T) -> T{
    switch gDevEnv {
    case .DEVELOP:
        return dev
    case .PREVIEW:
        return pre
    case .RELEASE:
        return rel
    }
}

/// Base HOST

var gBaseHOST: String {
    return YDDevEnv(dev: kBaseHOSTDev, pre: kBaseHOSTPre, rel: kBaseHOSTRel)
}
/// Base URL
var gBaseURL: String {
    return YDDevEnv(dev: kBaseURLDev, pre: kBaseURLPre, rel: kBaseURLRel)
}

/// Out URL
var gOutURL: String {
    return YDDevEnv(dev: kBaseURLDev, pre: kBaseURLPre, rel: kBaseURLRel)
}


/// 打印当前运行环境
func AIPrintEnvironment() {
    switch gDevEnv {
    case .DEVELOP:
        LogInfo("......现在是开发环境......")
    case .PREVIEW:
        LogInfo("......现在是预发布环境......")
    case .RELEASE:
        LogInfo("......现在是线上环境......")
    }
}
