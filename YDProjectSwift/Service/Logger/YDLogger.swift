//
//  YDLogger.swift
//  YDProjectSwift
//
//  Created by 王远东 on 2024/3/26.
//

import Foundation
import YDLogger

func LogError(_ frmt: String) {
    YDLoggerObjc.ydLogError(frmt)
}

func LogInfo(_ frmt: String) {
    YDLoggerObjc.ydLogInfo(frmt)
}

func LogDetail(_ frmt: String) {
    YDLoggerObjc.ydLogDetail(frmt)
}

func LogDebug(_ frmt: String) {
    YDLoggerObjc.ydLogDebug(frmt)
}

func LogVerbose(_ frmt: String) {
    YDLoggerObjc.ydLogVerbose(frmt)
}

func LogMonitorDetail(_ frmt: String) {
    YDLoggerObjc.ydLogMonitorDetail(frmt)
}

class YDLogger {
   static func startLog() {
        YDLoggerObjc.startOpen()
    }
}
