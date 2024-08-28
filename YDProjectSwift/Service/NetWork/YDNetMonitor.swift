//
//  YDNetMonitor.swift
//  YDProjectSwift
//
//  Created by 王远东 on 2024/3/26.
//

import Foundation
import Alamofire

enum YDNetStatus {
    case unknown, notReachable, wifi, wwan
    func netStatusDes() -> String {
        switch self {
        case .unknown:
            return "未知网络状态"
        case .notReachable:
            return "网络不可用"
        case .wifi:
            return "wifi"
        case .wwan:
            return "移动网络"
        }
    }
}

/// 网络状态改变通知
let kNetStatusChangeNotifation = NSNotification.Name("YDNetStatusChange")

//MARK: 网络状态监测
extension YDNetwork {
    
    /// 开启网络状态监测
    static func startNetMonitor() {
        
        reachabilityManager?.startListening(onUpdatePerforming: { (status) in
            switch status {
            case .unknown:
                netStatus = .unknown
            case .notReachable:
                netStatus = .notReachable
            case .reachable(.cellular):
                netStatus = .wwan
            case .reachable(.ethernetOrWiFi):
                netStatus = .wifi
            }
            LogInfo("当前网络状态：" + netStatus.netStatusDes())
            NotificationCenter.default.post(name: kNetStatusChangeNotifation, object: nil)
        })
    }
    
    /// 关闭网络状态监测
    static func stopNetMonitor() {
        reachabilityManager?.stopListening()
    }
}
