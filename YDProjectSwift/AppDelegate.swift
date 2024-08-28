//
//  AppDelegate.swift
//  YDProjectSwift
//
//  Created by 王远东 on 2024/3/25.
//

import UIKit
import YDLogger
@_exported import SnapKit
@_exported import IQKeyboardManagerSwift
@_exported import YDAuthorizationUtil

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
//    var window: UIWindow?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        // MARK: Window
//        self.window = UIWindow.init(frame: UIScreen.main.bounds)
//        if let window = self.window {
//            window.backgroundColor = UIColor.white
//            window.rootViewController = OtherViewController()
//            window.makeKeyAndVisible()
//        }
//        if #available(iOS 13.0, *) {
//           // 通知注册方式看场景进行添加，不需要可以去除
//           NotificationCenter.default.addObserver(forName: UIScene.willConnectNotification, object: nil, queue: nil) { (note) in
//               self.window?.windowScene = note.object as? UIWindowScene
//           }
//           // 主要注册
//           for windowScene in UIApplication.shared.connectedScenes {
//               if (windowScene.activationState == UIScene.ActivationState.foregroundActive) {
//                   self.window?.windowScene = windowScene as? UIWindowScene
//               }
//           }
//        }
        becomeEffective()
        configAppEnv()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

// MARK: config App Env
extension AppDelegate {
    func configAppEnv() {
#if YDProjectSwift
        LogInfo("======线上环境======")
#elseif YDProjectSwiftPre
        LogInfo("======预发环境======")
#elseif YDProjectSwiftDev
        LogInfo("======测试环境======")
#endif
    }
}

extension AppDelegate {
    
    func becomeEffective() {
        YDLogger.startLog()
        YDNetwork.startNetMonitor()
        // MARK: 打印当前运行环境
        AIPrintEnvironment()
        LogInfo("appName: \(appdisplayName) appVersion: \(appversion) buildCode: \(buildCode) modelName: \(String(describing: UIDevice.current.machineModelName)) version: \(gSystemVersion)")
        
        // MARK: UDID
        DispatchQueue.global().async {
            print(">deviceId: \(deviceId)")
        }
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
}
