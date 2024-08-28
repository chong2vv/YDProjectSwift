//
//  UIViewController+YD.swift
//  YDProjectSwift
//
//  Created by 王远东 on 2024/8/28.
//

import Foundation

extension UIViewController {
    func ydPresent(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        viewControllerToPresent.modalPresentationStyle = .fullScreen
        viewControllerToPresent.view.backgroundColor = UIColor.white
        self.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    func ydPushToVC(toVC: UIViewController, animated: Bool = true, backgroundColor: UIColor = .white) {
        if let navi = self.navigationController {
            toVC.view.backgroundColor = backgroundColor
            navi.pushViewController(toVC, animated: animated)
        }
    }
    
    static func topViewController() -> UIViewController? {
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        return self.topViewController(fromVC: rootVC)
    }
    
    private static func topViewController(fromVC: UIViewController?) -> UIViewController? {
        if let presentedVC = fromVC?.presentedViewController {
            return self.topViewController(fromVC: presentedVC)
        } else if let navi = fromVC as? UINavigationController {
            return self.topViewController(fromVC: navi.topViewController)
        } else if let tab = fromVC as? UITabBarController {
            return self.topViewController(fromVC: tab.selectedViewController)
        } else {
            return fromVC
        }
    }
    
    static func top2ViewController() -> UIViewController? {
            guard let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
                  let window = UIApplication.shared.windows.first(where: { $0.windowScene == scene }) else {
                return nil
            }

            return topViewController(fromVC: window.rootViewController)
        }
}
