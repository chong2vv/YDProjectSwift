//
//  YDNetworkLog.swift
//  YDProjectSwift
//
//  Created by 王远东 on 2024/4/8.
//

import Foundation

func YDLogNetError(path: String, code: Int, status: String, msg: String) {
    LogError("YDLogNetError <path：\(path) code: \(code) status: \(status) msg: \(msg)>")
}
